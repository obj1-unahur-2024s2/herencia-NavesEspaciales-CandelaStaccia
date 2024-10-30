class Nave {
    var velocidad = 0
    var direccion = 0
    var combustible = 0

    method velocidad() = velocidad
    method direccion() = direccion
    method combustible() = combustible

    method initialize() {
        if( not velocidad.between(0, 100000) ||
        not direccion.between(-10, 10) )
            self.error("No se puede instanciar")
    }

    method acelerar(cuanto) {
        velocidad = 100000.min(velocidad + cuanto)
    }

    method desacelerar(cuanto) {
        velocidad = 0.max(velocidad - cuanto)
    }

    method irHaciaElSol() {
        direccion = 10
    }

    method escaparDelSol() {
        direccion = -10
    }

    method ponerseParaleloAlSol() {
        direccion = 0
    }

    method acercarseUnPocoAlSol() {
        direccion = 10.min(direccion + 1)
    }

    method alejarseUnPocoDelSol() {
        direccion = (-10).max(direccion - 1)
    }

    method prepararViaje() 
    //clase abstracta. No permite crear instancias de Nave, solo sirve para modelar: method prepararViaje()
    // != de method prepararViaje() {} pq es un metodo vacio, sin implementacion
    //es necesario sobreescribir el metodo en las subclases pq si no esa subclase también es abstracta

    method accionAdicional() {
        self.cargarCombustible(30000)
        self.acelerar(5000)
    }

    method cargarCombustible(unaCantidad) {
        combustible = combustible + unaCantidad
    }

    method descargarCombustible(unaCantidad) {
        combustible = 0.max(combustible - unaCantidad)
    }

    method estaTranquila() {
        return combustible >= 4000 && velocidad <= 12000
    }

    method recibirAmenaza() {
        self.escapar()
        self.avisar()
    }

    method escapar() 
    method avisar()

    method estaDeRelajo() = self.estaTranquila() && self.tienePocaActividad()

    method tienePocaActividad() = true
}   



class NaveBaliza inherits Nave {
    var colorBaliza = "verde"
    var cambioDeColor = false

    method colorBaliza() = colorBaliza
    method cambioDeColor() = cambioDeColor

    method cambiarColorDeBaliza(colorNuevo) {
        if(not ["verde", "rojo", "azul"].contains(colorNuevo))
            self.error("No es un color permitido") //corta la ejecucion, sale del metodo
        colorBaliza = colorNuevo                  //no se ejecuta por esto ^
        cambioDeColor = true
    }

    override method prepararViaje() {
      self.accionAdicional()  
      colorBaliza = "verde" //self.cambiarColorDeBaliza("verde") //no tiene poca actividad con el metodo
      self.ponerseParaleloAlSol()
    }

    override method estaTranquila() {
        return super() && colorBaliza != "rojo"
    }

    override method escapar() {
        self.irHaciaElSol()
    }

    override method avisar() {
        self.cambiarColorDeBaliza("rojo")
    }

    override method tienePocaActividad() = not cambioDeColor
}


class NavePasajero inherits Nave {
    const property cantPasajeros
    var racionesComida = 0
    var racionesBebida = 0
    var racionesComidaServidas = 0

    method racionesComida() = racionesComida
    method racionesBebida() = racionesBebida
    method racionesComidaServidas() = racionesComidaServidas

    method cargarRacionesComida(unaCantidad) {
        racionesComida = racionesComida + unaCantidad
    }

    method cargarRacionesBebida(unaCantidad) {
        racionesBebida = racionesBebida + unaCantidad
    }

    override method prepararViaje() {
        self.accionAdicional()
        self.cargarRacionesComida(4 * cantPasajeros)
        self.cargarRacionesBebida(6 * cantPasajeros)
        self.acercarseUnPocoAlSol()
    }

    override method escapar() {
        self.acelerar(velocidad * 2)
    }

    override method avisar() {
        self.darRacionesComida(cantPasajeros)
        self.darRacionesBebida(2 * cantPasajeros)
    }

    method darRacionesComida(unaCantidad) {
        racionesComida = 0.max(racionesComida - unaCantidad)
        racionesComidaServidas = (racionesComidaServidas + unaCantidad).min(racionesComida)//para no servir mas de lo que se tiene
    }

    method darRacionesBebida(unaCantidad) {
        racionesBebida = 0.max(racionesBebida - unaCantidad)
    }

    override method tienePocaActividad() = racionesComidaServidas < 50
}


class NaveHospital inherits NavePasajero {
    var property quirofanosPreparados = false

    override method estaTranquila() {
        return super() && not quirofanosPreparados
    }//va a NavePasajero y no está, busca en Nave

    override method recibirAmenaza() {
        super()
        quirofanosPreparados = true
    }
}


class NaveCombate inherits Nave {
    var estaInvisible = true
    var misiles = false
    const property mensajes = [] 

    method ponerseVisible() {
        estaInvisible = false
    }

    method ponerseInvisible() {
        estaInvisible = true
    }

    method estaInvisible() = estaInvisible

    method desplegarMisiles() {
        misiles = true
    }

    method replegarMisiles() {
        misiles = false
    }

    method misilesDesplegados() = misiles

    method emitirMensaje(mensaje) {
        mensajes.add(mensaje)
    }

    method mensajesEmitidos() {
        return mensajes
    }

    method primerMensajeEmitido() {
        return mensajes.first()
    }

    method ultimoMensajeEmitido() {
        return mensajes.last()
    }

    method esEscueta() {
        return not mensajes.any({m => m.size() > 30})
    }//mensajes.all({m => m.size() <= 30})

    method emitioMensaje(mensaje) {
        return mensajes.contains(mensaje)
    }

    override method prepararViaje() {
        self.accionAdicional()
        estaInvisible = false //self.ponerseVisible()
        misiles = false //self.replegarMisiles()
        self.acelerar(15000)
        self.emitirMensaje("Saliendo en mision")
    }

    override method estaTranquila() {
        return super() && not misiles
    }

    override method escapar() {
        self.acercarseUnPocoAlSol()
        self.acercarseUnPocoAlSol()
    }

    override method avisar() {
        self.emitirMensaje("Amenaza recibida")
    }
}


class NaveSigilosa inherits NaveCombate {
    override method estaTranquila() {
        return super() && not self.estaInvisible() //estaInvisible
    }

    override method escapar() {
        super()
        self.desplegarMisiles()
        self.ponerseInvisible()
    }
}