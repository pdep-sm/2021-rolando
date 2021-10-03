class Guerrero {
	const valorBaseHechiceria = 3
	var property valorBaseLucha = 1
	var property hechizoPreferido = hechizoBasico
	const artefactos = []
	var property monedas = 100
	
	method adquirirArtefacto(artefacto) {
		if (artefacto.precio() <= monedas) {
			self.agregarArtefacto(artefacto)
			self.pagar(artefacto.precio())
		}
	}
	
	method canjearHechizo(hechizo) {
		const totalAPagar = self.totalAPagar(hechizo)
		
		if (totalAPagar <= monedas) {
			hechizoPreferido = hechizo
			self.pagar(totalAPagar)
		}
	}
	
	method totalAPagar(hechizo) =
		hechizo.precio() - hechizoPreferido.precio().div(2)
	
	method pagar(precio) {
		// self.monedas(monedas - precio)
		monedas -= precio
	}
	
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
		artefactos.sum{artefacto => artefacto.unidadesDeLucha(self)}
	
	method esPoderoso() = hechizoPreferido.esPoderoso()

	method mejorArtefactoSin(artefacto){
        const listaSinArtefacto = artefactos.filter{ unArtefacto => unArtefacto != artefacto}
        listaSinArtefacto.add(artefactoNulo)
        
        return listaSinArtefacto.max{ unArtefacto => unArtefacto.unidadesDeLucha(self)}
    } 
}

class Artefacto {
	var property fechaDeCompra = null
	const peso
	
	method pesoTotal() = 0.max(peso - self.factorDeCorreccion())
	method factorDeCorreccion() = 1.min((new Date() - fechaDeCompra) / 1000)
}

/*
 * Ahora, además de las espadas del destino, puede haber otras espadas, como así 
 * también hachas y lanzas, pero todas aportan 3 puntos de 	lucha.
 */
// TODO el peso base no es 0, el peso adicional es 0
class Arma inherits Artefacto(peso = 0) {
	const unidadesDeLucha = 3
	
	method unidadesDeLucha(propietario) = unidadesDeLucha
	method precio() = 5 * unidadesDeLucha
}

// TODO el peso base no es 0, el peso adicional es 0
object collarDivino inherits Artefacto(peso = 0){
	var property cantidadDePerlas = 5

	method unidadesDeLucha(propietario) = cantidadDePerlas
	method precio() = 2 * cantidadDePerlas
	override method pesoTotal() = super() + 0.5 * cantidadDePerlas
}

/*
 * Las máscaras también son muchas, algunas más oscuras que otras. 
 * Para ello se conoce un índice de oscuridad que va de 1 (lo más oscuro) a 0 
 * (lo más claro), que afecta proporcionalmente las unidades de lucha que aporta, 
 * de la siguiente manera:

		valor de la lucha = (la mitad del valor de fuerza oscura * 
		 						índice de oscuridad) considerando el mínimo

 * Para cualquier máscara inicialmente su mínimo de poder es 4, pero luego dicho 
 * mínimo puede variar en forma independiente. 

 */

/*
 * Máscara: 70 monedas, más tantas monedas como fuerza oscura haya al momento de 
 * la transacción, multiplicada por el índice de oscuridad de la máscara.
 */
class Mascara inherits Artefacto {
	var property indiceDeOscuridad = 1
	var property poderMinimo = 4
	
	method unidadesDeLucha() = (fuerzaOscura.valor().div(2) * indiceDeOscuridad).max(poderMinimo) 
	method unidadesDeLucha(propietario) = self.unidadesDeLucha()
		
	method precio() = 70 + fuerzaOscura.valor() * indiceDeOscuridad
	override method pesoTotal() = super() + self.pesoAgregado()
	method pesoAgregado() = 0.max(self.unidadesDeLucha() - 3)
}

object fuerzaOscura {
	var valor = 5
	
	method valor() = valor
	method eclipse() {
		valor *= 2
	}
}

object hechizoBasico {
	const property poder = 10
	const property precio = 10
	
	method esPoderoso() = false
	method unidadesDeLucha(propietario) = self.poder()
	method precio(armadura) = armadura.valorBase() + precio
}

/*
 * Además del maléfico hay muchos otros hechizos a los que llamamos de "logos", 
* cada uno con su propio nombre. El poder de hechicería es un múltiplo de la 
* cantidad de letras de su nombre, donde el valor por el cual se multiplica puede 
* variar de hechizo en hechizo. La forma de saber si es poderoso sigue siendo si 
* su poder es mayor a 15.
*/

class HechizoDeLogos {
	var property nombre = ""
	var property multiplicador = 1
	
	method poder() = nombre.length() * multiplicador
	method esPoderoso() = self.poder() > 15
	method unidadesDeLucha(propietario) = self.poder()
	method precio() = self.poder()
	method precio(armadura) = armadura.valorBase() + self.precio()
}

class HechizoComercial inherits HechizoDeLogos(multiplicador = 2) {
	var property porcentaje = 20
	
	override method poder() = super() * porcentaje / 100
	//TODO revisar si hay que heredar unidadesDeLucha/1, precio/0 y precio/1
}

class LibroDeHechizos {
	const hechizos = []
	
	method agregarHechizo(hechizo) { 
		hechizos.add(hechizo)
	}

	method poder() = 
		self.hechizosPoderosos().sum{hechizo => hechizo.poder()}
		
	method hechizosPoderosos() = hechizos.filter{hechizo => hechizo.esPoderoso()}
	
	method esPoderoso() = hechizos.any{hechizo => hechizo.esPoderoso()}
	
	/*
	 * Libro de hechizos: 10 monedas por cada hechizo que contenga, más una moneda 
	 * por cada unidad de hechicería total si el hechizo es poderoso ó 0 en caso 
	 * contrario. Ejemplo: libro con  dos hechizos, donde el primero tiene un poder 
	 * de 30 y el segundo de 34, el valor será de: (2*10) + (30 + 34) = 84 monedas.
	 */
	method precio() = hechizos.length() * 10 + self.poder()
}

/*
 * Ahora las armaduras disponibles son muchas, cada personaje puede tener una, 
 * más de una o no tener ninguna. Cada una puede tener un refuerzo diferente, 
 * pero sigue siendo único. La fuerza que  aporta se calcula de igual manera, 
 * pero el valor base de la armadura, si bien no se modifica, no tiene por qué 
 * ser el mismo para todas (la que lleva puesta rolando será 2, habrá otras con 
 * otros valores).
 */

class Armadura {
	var property refuerzo = refuerzoNulo
	var property valorBase = 2 

	method unidadesDeLucha(propietario) = 
		valorBase + refuerzo.unidadesDeLucha(propietario)
	method precio() = refuerzo.precio(self)
}

/*
 * Los refuerzos son los mismos, pero con las siguientes particularidades:
		Cota de malla: Son muchas, cada una suma una cantidad diferente de unidad 
		de lucha.
		Bendición: Igual que en la primera entrega (pero recordar que ahora hay 
		muchos personajes).
		Hechizo. Igual que en la primera entrega (considerando que ahora hay más 
		cantidad de hechizos).
		Ninguno. Se mantiene la posibilidad que una armadura pueda no estar 
		reforzada.
 */

class CotaDeMalla {
	var property unidades = 1
	
	method unidadesDeLucha(propietario) = unidades
	method precio(armadura) = unidades / 2
}

/** NULL OBJECT */
object refuerzoNulo {
	method unidadesDeLucha(propietario) = 0
	method precio(armadura) = 2
}

/** NULL OBJECT */
object artefactoNulo {
	method unidadesDeLucha(propietario) = 0
}

//Bendición: suma tantas unidades de lucha como nivel de hechicería tenga quien 
// posee la armadura.
object bendicion {
	method unidadesDeLucha(propietario) = propietario.nivelDeHechiceria()
	method precio(armadura) = armadura.valorBase()
}

/* ESPEJO Y LIBRO DE HECHIZOS
Su comportamiento es el mismo. Simplemente, ahora son muchos los personajes que 
pueden contar con espejos o libros de hechizos entre sus pertenencias. 
Para pensar:
 - ¿Es necesario, conveniente o indistinto que haya muchos espejos y libros de 
hechizos o que sigan siendo únicos? 
 - Replantearse la pregunta de la primera entrega acerca de la posibilidad de un 
libro de hechizo que tenga entre sus hechizos un libro de hechizos.  
 */
// TODO el peso base no es 0, el peso adicional es 0
object espejoFantastico inherits Artefacto(peso = 0) {
	const property precio = 90
	
	method unidadesDeLucha(propietario) = 
		propietario.mejorArtefactoSin(self).unidadesDeLucha(propietario)
}

 

