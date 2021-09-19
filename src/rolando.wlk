object rolando {
	const valorBaseHechiceria = 3
	var property valorBaseLucha = 1
	var property hechizoPreferido = hechizoBasico
	const artefactos = []
	
	method agregarArtefacto(nuevoArtefacto) {
		artefactos.add(nuevoArtefacto)
	}
	
	method quitarArtefacto(artefacto) {
		artefactos.remove(artefacto)
	}

	method nivelDeHechiceria() =
		valorBaseHechiceria * hechizoPreferido.poder() + fuerzaOscura.valor()
		
	method valorDeLucha() = valorBaseLucha + self.sumaValoresArtefactos()
	
	method sumaValoresArtefactos() = 
		//artefactos.sum{artefacto => artefacto.unidadesDeLucha()}
		artefactos.sum{artefacto => artefacto.unidadesDeLucha(self)}
	
	method esPoderoso() = hechizoPreferido.esPoderoso()

	method mejorArtefactoSin(artefacto){
        const listaSinArtefacto = artefactos.filter{unArtefacto => unArtefacto != artefacto}
        listaSinArtefacto.add(artefactoNulo)
        return listaSinArtefacto.max{unArtefacto => unArtefacto.unidadesDeLucha(self)}
        /*
         * if(listaSinArtefacto.isEmpty())
        	return artefactoNulo
        else
        	return listaSinArtefacto.max{unArtefacto => unArtefacto.unidadesDeLucha(self)}
    	* 
    	*/
    } 
}

object espadaDelDestino {
	method unidadesDeLucha(propietario) = 3
}

object collarDivino {
	var property cantidadDePerlas = 5

	method unidadesDeLucha(propietario) = cantidadDePerlas
}

object mascaraOscura {
	method unidadesDeLucha(propietario) = fuerzaOscura.valor().div(2).max(4) 
}

object fuerzaOscura {
	var valor = 5
	
	method valor() = valor
	method eclipse() {
		valor *= 2
	}
}

object hechizoBasico {
	//method poder() = 10
	const property poder = 10
	
	method esPoderoso() = false
	method unidadesDeLucha(propietario) = self.poder()
}

object espectroMalefico {
	var property nombre = "espectro maléfico"
	
	method poder() = nombre.length()
	method esPoderoso() = self.poder() > 15
	method unidadesDeLucha(propietario) = self.poder()
}

object libroDeHechizos {
	const hechizos = []
	
	method agregarHechizo(hechizo) { 
		hechizos.add(hechizo)
	}

	method poder() = 
		self.hechizosPoderosos().sum{hechizo => hechizo.poder()}
		
	method hechizosPoderosos() = hechizos.filter{hechizo => hechizo.esPoderoso()}
	
	method esPoderoso() = hechizos.any{hechizo => hechizo.esPoderoso()}
	//method esPoderoso() = not self.hechizosPoderosos().isEmpty()
}

object armadura {
	var property refuerzo = refuerzoNulo
	//var property propietario = rolando
	
	//method unidadesDeLucha() = 2 + refuerzo.unidadesDeLucha(propietario.nivelDeHechiceria())
	method unidadesDeLucha(propietario) = 2 + refuerzo.unidadesDeLucha(propietario)
	//si no tuviéramos null object, sería así:
	//method unidadesDeLucha() = 2 + if(refuerzo == null) 0 else refuerzo.unidadesDeLucha()
}

object cotaDeMalla {
	//const property unidadesDeLucha = 1
	//method unidadesDeLucha(nivelDeHechiceria) = 1
	method unidadesDeLucha(propietario) = 1
}

/** NULL OBJECT */
object refuerzoNulo {
	//const property unidadesDeLucha = 0
	//method unidadesDeLucha(nivelDeHechiceria) = 0
	method unidadesDeLucha(propietario) = 0
}

/** NULL OBJECT */
object artefactoNulo {
	method unidadesDeLucha(propietario) = 0
}

//Bendición: suma tantas unidades de lucha como nivel de hechicería tenga quien posee la armadura.
object bendicion {
	//method unidadesDeLucha(nivelDeHechiceria) = nivelDeHechiceria
	method unidadesDeLucha(propietario) = propietario.nivelDeHechiceria()
}

//Hechizo: puede ser el espectro maléfico o el hechizo básico. 
//En cualquier caso, aumentan la habilidad de lucha lo mismo que su poder de hechicería. 
/* 
object hechizo {
	var property tipoDeHechizo = hechizoBasico
	
	method unidadesDeLucha(propietario) = tipoDeHechizo.poder()
}
*/

/** El “espejo fantástico” se comporta de la misma manera que la mejor 
de sus restantes pertenencias. Se considera la mejor pertenencia a la 
que aporta más puntos de lucha. Si sólo tuviera como pertenencia al espejo 
fantástico, su aporte a la lucha sería nulo.
 */
object espejoFantastico {
	method unidadesDeLucha(propietario) = 
		propietario.mejorArtefactoSin(self).unidadesDeLucha(propietario)
}

 

