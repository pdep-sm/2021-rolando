import artefactos.*
import hechizos.*

class Guerrero {
	const valorBaseHechiceria = 3
	var property valorBaseLucha = 1
	var property hechizoPreferido = hechizoBasico
	const artefactos = []
	var property monedas = 100
	
	method adquirirArtefacto(artefacto) {
		try {
			self.pagar(artefacto.precio())
			self.agregarArtefacto(artefacto)	
		} catch ex: MonedasInsuficientesException {
			throw new ImporteException(
				importe = ex.importe(), 
				cosa = artefacto, 
				message = "Monedas insuficientes para realizar la compra del artefacto",
				cause = ex)
		} 
		
	}
	
	method canjearHechizo(hechizo) {
		try {
			self.pagar(self.totalAPagar(hechizo))
			hechizoPreferido = hechizo
		} catch ex: MonedasInsuficientesException {
			throw new ImporteException(
				importe = ex.importe(), 
				cosa = hechizo, 
				message = "Monedas insuficientes para canjear el hechizo",
				cause = ex)
		}
	}
	
	method totalAPagar(hechizo) =
		hechizo.precio() - hechizoPreferido.precio().div(2)
	
	method pagar(precio) {
		if (precio > monedas)
			throw new MonedasInsuficientesException(
				importe = precio, 
				monedas = monedas, 
				message = "No se puede abonar el importe"
			)
			
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
    
    method cantidadArtefactos() = artefactos.size()
}

class NPC inherits Guerrero {
	var property nivel
	
	override method valorDeLucha() = super() * nivel.multiplicador()
	
	/** solución con bloques 
	override method valorDeLucha() = nivel.apply(super())
	*/
	
	/** solución delegando al Nivel 
	override method valorDeLucha() = nivel.modificarValorLucha(super())
	*/
}

class Nivel {
	const property multiplicador
	
	method modificarValorLucha(valor) = multiplicador * valor
}

const facil = new Nivel(multiplicador = 1)
const moderado = new Nivel(multiplicador = 2)
const dificil = new Nivel(multiplicador = 4)

const facil2 = { valorLucha => valorLucha }
const moderado2 = { valorLucha => valorLucha * 2 }
const dificil2 = { valorLucha => valorLucha * 4 }


object fuerzaOscura {
	var valor = 5
	
	method valor() = valor
	method eclipse() {
		valor *= 2
	}
}

class ImporteException inherits Exception {
	const property importe
	const property cosa		
}

// por ejemplo...
class MonedasInsuficientesException inherits Exception {
	const property importe
	const property monedas
}
