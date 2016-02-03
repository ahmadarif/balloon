package
{
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
    import flash.utils.Dictionary;

    public class PhysicsData extends Object
	{
		// ptm ratio
        public var ptm_ratio:Number = 32;
		
		// the physcis data 
		var dict:Dictionary;
		
        //
        // bodytype:
        //  b2_staticBody
        //  b2_kinematicBody
        //  b2_dynamicBody

        public function createBody(name:String, world:b2World, bodyType:uint, userData:*):b2Body
        {
            var fixtures:Array = dict[name];

            var body:b2Body;
            var f:Number;

            // prepare body def
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type = bodyType;
            bodyDef.userData = userData;

            // create the body
            body = world.CreateBody(bodyDef);

            // prepare fixtures
            for(f=0; f<fixtures.length; f++)
            {
                var fixture:Array = fixtures[f];

                var fixtureDef:b2FixtureDef = new b2FixtureDef();

                fixtureDef.density=fixture[0];
                fixtureDef.friction=fixture[1];
                fixtureDef.restitution=fixture[2];

                fixtureDef.filter.categoryBits = fixture[3];
                fixtureDef.filter.maskBits = fixture[4];
                fixtureDef.filter.groupIndex = fixture[5];
                fixtureDef.isSensor = fixture[6];

                if(fixture[7] == "POLYGON")
                {                    
                    var p:Number;
                    var polygons:Array = fixture[8];
                    for(p=0; p<polygons.length; p++)
                    {
                        var polygonShape:b2PolygonShape = new b2PolygonShape();
                        polygonShape.SetAsArray(polygons[p], polygons[p].length);
                        fixtureDef.shape=polygonShape;

                        body.CreateFixture(fixtureDef);
                    }
                }
                else if(fixture[7] == "CIRCLE")
                {
                    var circleShape:b2CircleShape = new b2CircleShape(fixture[9]);                    
                    circleShape.SetLocalPosition(fixture[8]);
                    fixtureDef.shape=circleShape;
                    body.CreateFixture(fixtureDef);                    
                }                
            }

            return body;
        }

		
        public function PhysicsData(): void
		{
			dict = new Dictionary();
			

			dict["WallHorisontal"] = [

										[
											// density, friction, restitution
                                            2, 0, 0.2,
                                            // categoryBits, maskBits, groupIndex, isSensor
											1, 65535, 0, false,
											'POLYGON',

                                            // vertexes of decomposed polygons
                                            [

                                                [   new b2Vec2(2/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(479.5/ptm_ratio, 39/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 39.5/ptm_ratio)  ,  new b2Vec2(-0.5/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(1/ptm_ratio, -0.5/ptm_ratio)  ] ,
                                                [   new b2Vec2(479.5/ptm_ratio, 39/ptm_ratio)  ,  new b2Vec2(2/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(479/ptm_ratio, -0.5/ptm_ratio)  ]
											]

										]

									];

			dict["WallVertical"] = [

										[
											// density, friction, restitution
                                            2, 0, 0.2,
                                            // categoryBits, maskBits, groupIndex, isSensor
											1, 65535, 0, false,
											'POLYGON',

                                            // vertexes of decomposed polygons
                                            [

                                                [   new b2Vec2(2/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(39.5/ptm_ratio, 1/ptm_ratio)  ,  new b2Vec2(39.5/ptm_ratio, 799/ptm_ratio)  ,  new b2Vec2(38/ptm_ratio, 799.5/ptm_ratio)  ,  new b2Vec2(-0.5/ptm_ratio, 798/ptm_ratio)  ,  new b2Vec2(-0.5/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(1/ptm_ratio, -0.5/ptm_ratio)  ] ,
                                                [   new b2Vec2(39.5/ptm_ratio, 1/ptm_ratio)  ,  new b2Vec2(2/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(39/ptm_ratio, -0.5/ptm_ratio)  ] ,
                                                [   new b2Vec2(-0.5/ptm_ratio, 798/ptm_ratio)  ,  new b2Vec2(38/ptm_ratio, 799.5/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 799.5/ptm_ratio)  ]
											]

										]

									];

			dict["baloon0"] = [

										[
											// density, friction, restitution
                                            2, 0, 0.2,
                                            // categoryBits, maskBits, groupIndex, isSensor
											1, 65535, 0, false,
											'POLYGON',

                                            // vertexes of decomposed polygons
                                            [

                                                [   new b2Vec2(11.5/ptm_ratio, 39/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 38.5/ptm_ratio)  ,  new b2Vec2(15.5/ptm_ratio, 41/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 41.5/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 41.5/ptm_ratio)  ] ,
                                                [   new b2Vec2(27.5/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(27.5/ptm_ratio, 22/ptm_ratio)  ,  new b2Vec2(23.5/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(-0.5/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(1.5/ptm_ratio, 6/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 0.5/ptm_ratio)  ] ,
                                                [   new b2Vec2(6/ptm_ratio, 34.5/ptm_ratio)  ,  new b2Vec2(-0.5/ptm_ratio, 23/ptm_ratio)  ,  new b2Vec2(-0.5/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(23.5/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 38.5/ptm_ratio)  ,  new b2Vec2(11.5/ptm_ratio, 39/ptm_ratio)  ]
											]

										]

									];

			dict["baloon1"] = [

										[
											// density, friction, restitution
                                            2, 0, 0.2,
                                            // categoryBits, maskBits, groupIndex, isSensor
											1, 65535, 0, false,
											'POLYGON',

                                            // vertexes of decomposed polygons
                                            [

                                                [   new b2Vec2(30.5/ptm_ratio, 98/ptm_ratio)  ,  new b2Vec2(35.5/ptm_ratio, 101/ptm_ratio)  ,  new b2Vec2(37.5/ptm_ratio, 103/ptm_ratio)  ,  new b2Vec2(36/ptm_ratio, 104.5/ptm_ratio)  ,  new b2Vec2(29/ptm_ratio, 104.5/ptm_ratio)  ] ,
                                                [   new b2Vec2(30.5/ptm_ratio, 98/ptm_ratio)  ,  new b2Vec2(36/ptm_ratio, 97.5/ptm_ratio)  ,  new b2Vec2(35.5/ptm_ratio, 101/ptm_ratio)  ] ,
                                                [   new b2Vec2(27/ptm_ratio, 96.5/ptm_ratio)  ,  new b2Vec2(13.5/ptm_ratio, 82/ptm_ratio)  ,  new b2Vec2(2.5/ptm_ratio, 62/ptm_ratio)  ,  new b2Vec2(68.5/ptm_ratio, 49/ptm_ratio)  ,  new b2Vec2(64.5/ptm_ratio, 61/ptm_ratio)  ,  new b2Vec2(50.5/ptm_ratio, 84/ptm_ratio)  ,  new b2Vec2(36/ptm_ratio, 97.5/ptm_ratio)  ,  new b2Vec2(30.5/ptm_ratio, 98/ptm_ratio)  ] ,
                                                [   new b2Vec2(29/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(2.5/ptm_ratio, 62/ptm_ratio)  ,  new b2Vec2(-0.5/ptm_ratio, 52/ptm_ratio)  ,  new b2Vec2(-0.5/ptm_ratio, 34/ptm_ratio)  ,  new b2Vec2(6.5/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(15.5/ptm_ratio, 6/ptm_ratio)  ] ,
                                                [   new b2Vec2(52/ptm_ratio, 3.5/ptm_ratio)  ,  new b2Vec2(62.5/ptm_ratio, 15/ptm_ratio)  ,  new b2Vec2(68.5/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(68.5/ptm_ratio, 49/ptm_ratio)  ,  new b2Vec2(2.5/ptm_ratio, 62/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(43/ptm_ratio, -0.5/ptm_ratio)  ]
											]

										]

									];

			dict["baloon2"] = [

										[
											// density, friction, restitution
                                            2, 0, 0.2,
                                            // categoryBits, maskBits, groupIndex, isSensor
											1, 65535, 0, false,
											'POLYGON',

                                            // vertexes of decomposed polygons
                                            [

                                                [   new b2Vec2(46.5/ptm_ratio, 148/ptm_ratio)  ,  new b2Vec2(53.5/ptm_ratio, 153/ptm_ratio)  ,  new b2Vec2(56.5/ptm_ratio, 156/ptm_ratio)  ,  new b2Vec2(55/ptm_ratio, 157.5/ptm_ratio)  ,  new b2Vec2(45/ptm_ratio, 157.5/ptm_ratio)  ] ,
                                                [   new b2Vec2(46.5/ptm_ratio, 148/ptm_ratio)  ,  new b2Vec2(53/ptm_ratio, 146.5/ptm_ratio)  ,  new b2Vec2(53.5/ptm_ratio, 153/ptm_ratio)  ] ,
                                                [   new b2Vec2(38/ptm_ratio, 142.5/ptm_ratio)  ,  new b2Vec2(21.5/ptm_ratio, 124/ptm_ratio)  ,  new b2Vec2(6.5/ptm_ratio, 98/ptm_ratio)  ,  new b2Vec2(85.5/ptm_ratio, 113/ptm_ratio)  ,  new b2Vec2(74.5/ptm_ratio, 128/ptm_ratio)  ,  new b2Vec2(59.5/ptm_ratio, 143/ptm_ratio)  ,  new b2Vec2(53/ptm_ratio, 146.5/ptm_ratio)  ,  new b2Vec2(46.5/ptm_ratio, 148/ptm_ratio)  ] ,
                                                [   new b2Vec2(6.5/ptm_ratio, 98/ptm_ratio)  ,  new b2Vec2(-0.5/ptm_ratio, 76/ptm_ratio)  ,  new b2Vec2(-0.5/ptm_ratio, 54/ptm_ratio)  ,  new b2Vec2(4.5/ptm_ratio, 36/ptm_ratio)  ,  new b2Vec2(103.5/ptm_ratio, 50/ptm_ratio)  ,  new b2Vec2(103.5/ptm_ratio, 71/ptm_ratio)  ,  new b2Vec2(96.5/ptm_ratio, 93/ptm_ratio)  ,  new b2Vec2(85.5/ptm_ratio, 113/ptm_ratio)  ] ,
                                                [   new b2Vec2(46/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(47/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(10.5/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(15.5/ptm_ratio, 18/ptm_ratio)  ,  new b2Vec2(31/ptm_ratio, 4.5/ptm_ratio)  ] ,
                                                [   new b2Vec2(4.5/ptm_ratio, 36/ptm_ratio)  ,  new b2Vec2(10.5/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(47/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(70/ptm_ratio, 1.5/ptm_ratio)  ,  new b2Vec2(85/ptm_ratio, 11.5/ptm_ratio)  ,  new b2Vec2(93.5/ptm_ratio, 22/ptm_ratio)  ,  new b2Vec2(99.5/ptm_ratio, 34/ptm_ratio)  ,  new b2Vec2(103.5/ptm_ratio, 50/ptm_ratio)  ] ,
                                                [   new b2Vec2(70/ptm_ratio, 1.5/ptm_ratio)  ,  new b2Vec2(47/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(63/ptm_ratio, -0.5/ptm_ratio)  ]
											]

										]

									];

			dict["baloon3"] = [

										[
											// density, friction, restitution
                                            2, 0, 0.2,
                                            // categoryBits, maskBits, groupIndex, isSensor
											1, 65535, 0, false,
											'POLYGON',

                                            // vertexes of decomposed polygons
                                            [

                                                [   new b2Vec2(73/ptm_ratio, 208.5/ptm_ratio)  ,  new b2Vec2(60/ptm_ratio, 208.5/ptm_ratio)  ,  new b2Vec2(70.5/ptm_ratio, 202/ptm_ratio)  ,  new b2Vec2(74.5/ptm_ratio, 207/ptm_ratio)  ] ,
                                                [   new b2Vec2(60/ptm_ratio, 208.5/ptm_ratio)  ,  new b2Vec2(59.5/ptm_ratio, 206/ptm_ratio)  ,  new b2Vec2(62.5/ptm_ratio, 202/ptm_ratio)  ,  new b2Vec2(70/ptm_ratio, 194.5/ptm_ratio)  ,  new b2Vec2(70.5/ptm_ratio, 202/ptm_ratio)  ] ,
                                                [   new b2Vec2(62.5/ptm_ratio, 196/ptm_ratio)  ,  new b2Vec2(70/ptm_ratio, 194.5/ptm_ratio)  ,  new b2Vec2(62.5/ptm_ratio, 202/ptm_ratio)  ] ,
                                                [   new b2Vec2(46/ptm_ratio, 183.5/ptm_ratio)  ,  new b2Vec2(32.5/ptm_ratio, 168/ptm_ratio)  ,  new b2Vec2(127.5/ptm_ratio, 123/ptm_ratio)  ,  new b2Vec2(112.5/ptm_ratio, 150/ptm_ratio)  ,  new b2Vec2(97.5/ptm_ratio, 170/ptm_ratio)  ,  new b2Vec2(85.5/ptm_ratio, 183/ptm_ratio)  ,  new b2Vec2(70/ptm_ratio, 194.5/ptm_ratio)  ,  new b2Vec2(62.5/ptm_ratio, 196/ptm_ratio)  ] ,
                                                [   new b2Vec2(21.5/ptm_ratio, 152/ptm_ratio)  ,  new b2Vec2(7.5/ptm_ratio, 125/ptm_ratio)  ,  new b2Vec2(-0.5/ptm_ratio, 95/ptm_ratio)  ,  new b2Vec2(-0.5/ptm_ratio, 79/ptm_ratio)  ,  new b2Vec2(137.5/ptm_ratio, 74/ptm_ratio)  ,  new b2Vec2(135.5/ptm_ratio, 100/ptm_ratio)  ,  new b2Vec2(127.5/ptm_ratio, 123/ptm_ratio)  ,  new b2Vec2(32.5/ptm_ratio, 168/ptm_ratio)  ] ,
                                                [   new b2Vec2(96/ptm_ratio, 4.5/ptm_ratio)  ,  new b2Vec2(107/ptm_ratio, 11.5/ptm_ratio)  ,  new b2Vec2(119/ptm_ratio, 23.5/ptm_ratio)  ,  new b2Vec2(130.5/ptm_ratio, 43/ptm_ratio)  ,  new b2Vec2(135.5/ptm_ratio, 59/ptm_ratio)  ,  new b2Vec2(3.5/ptm_ratio, 58/ptm_ratio)  ,  new b2Vec2(66/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(79/ptm_ratio, -0.5/ptm_ratio)  ] ,
                                                [   new b2Vec2(3.5/ptm_ratio, 58/ptm_ratio)  ,  new b2Vec2(135.5/ptm_ratio, 59/ptm_ratio)  ,  new b2Vec2(137.5/ptm_ratio, 74/ptm_ratio)  ,  new b2Vec2(-0.5/ptm_ratio, 79/ptm_ratio)  ] ,
                                                [   new b2Vec2(65/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(66/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(3.5/ptm_ratio, 58/ptm_ratio)  ,  new b2Vec2(7.5/ptm_ratio, 47/ptm_ratio)  ,  new b2Vec2(18.5/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(28.5/ptm_ratio, 17/ptm_ratio)  ,  new b2Vec2(38/ptm_ratio, 9.5/ptm_ratio)  ,  new b2Vec2(52/ptm_ratio, 2.5/ptm_ratio)  ]
											]

										]

									];

			dict["swipe-img"] = [

										[
											// density, friction, restitution
                                            2, 0, 10,
                                            // categoryBits, maskBits, groupIndex, isSensor
											1, 65535, 0, false,
											'POLYGON',

                                            // vertexes of decomposed polygons
                                            [

                                                [   new b2Vec2(0/ptm_ratio, 19.5/ptm_ratio)  ,  new b2Vec2(-0.5/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(1/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, -0.5/ptm_ratio)  ,  new b2Vec2(19.5/ptm_ratio, 19/ptm_ratio)  ]
											]

										]

									];

		}
	}
}
