object rolando {
	const valorBaseHechiceria = 3
	var valorBaseLucha = 1
	var hechizoPreferido = hechizoBasico
	const artefactos = []

	method valorBaseLucha(nuevoValor){
		valorBaseLucha = nuevoValor
	}

	method hechizoPreferido(nuevoHechizo) {
		hechizoPreferido = nuevoHechizo
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
	
	method sumaValoresArtefactos() = artefactos.sum{artefacto => artefacto.unidadesDeLucha()}
	
	method esPoderoso() = hechizoPreferido.esPoderoso()

}

object espadaDelDestino {
	method unidadesDeLucha() = 3
}

object collarDivino {
	var cantidadDePerlas = 5
	
	method cantidadDePerlas(nuevaCantidad){
		cantidadDePerlas = nuevaCantidad
	}
	method unidadesDeLucha() = cantidadDePerlas
}

object mascaraOscura {
	method unidadesDeLucha() = fuerzaOscura.valor().div(2).max(4) 
}

object fuerzaOscura {
	var valor = 5
	method valor() = valor
	method eclipse() {
		valor *= 2
	}
}

object hechizoBasico {
	method poder() = 10
	method esPoderoso() = false
}

object espectroMalefico {
	var nombre = "espectro maléfico"
	method nombre(nuevoNombre){
		nombre = nuevoNombre
	}
	method poder() = nombre.length()
	method esPoderoso() = self.poder() > 15
}

