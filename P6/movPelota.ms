myTraveller = $Sphere001
myFollower = $Box001
myFloor = $Plane001

/*Quitar claves a la pelota*/
deletekeys myTraveller

/*Determinar el inicio y fin de la animaci�n*/
ini = 0
fin = 500

fn getCollision t = (
	return IntersectRay myFloor (ray (at time t myFollower.pos) [0, 0, -1])
)

animate on (
	for t in ini to fin by 1 do (
		/*rayo de plano a curva en el momento t*/
		collision0 = getCollision t
		/*Posici�n actualo de la pelota*/
		p0 = collision0.pos + collision0.dir * myTraveller.radius
		/*Actualizar posicion de la pelota*/
		at time t myTraveller.pos = p0
			
		if t > ini do (
			if t < fin then (
				collision1 = getCollision (t + 1)	-- traza un rayo hacia el plano de la curva en el instante t
				p1 = collision1.pos + collision1.dir * myTraveller.radius	-- obtiene la posici�n siguiente de la bola
			) else (
				collision1 = getCollision ini	-- traza un rayo hacia el plano de la curva en el instante t
				p1 = collision1.pos + collision1.dir * myTraveller.radius	-- obtiene la posici�n siguiente de la bola
			)
			
			diff = p1 - p0		-- diferencia entre posici�n actual y siguiente
			len = Length diff	-- distancia entre las dos posiciones
			vec = diff / len	-- vector de movimiento normalizado
			
			rotAxis = cross vec collision0.dir	-- eje de rotaci�n
			ang = 360 * len / (myTraveller.radius * 2 * pi)	-- cantidad de rotaci�n
			rotDiff = quat ang rotAxis	-- quaternion para la rotaci�n desde la posici�n actual a la siguiente
			
			rotEuler = QuatToEuler rotDiff	-- conversi�n a rotaci�n de euler
			at time t rotate myTraveller rotEuler	-- rota la bola
		)
	)
)