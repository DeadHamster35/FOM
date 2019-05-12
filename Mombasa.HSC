
(script stub scenery AR0 none)
(script stub scenery AR1 none)
(script stub scenery AR2 none)
(script stub scenery AR3 none)
(script stub scenery AR4 none)
(script stub scenery AR5 none)

(script stub scenery GR0 none)
(script stub scenery GR1 none)
(script stub scenery GR2 none)
(script stub scenery GR3 none)
(script stub scenery GR4 none)
(script stub scenery GR5 none)


(global object_definition ar_obj "cmt\weapons\spv3\human\assault_rifle\assault_rifle")
(global object_definition br_obj "cmt\weapons\spv3\human\battle_rifle\battle_rifle")
(global object_definition dr_obj "cmt\weapons\spv3\human\dmr\dmr")
(global object_definition sg_obj "cmt\weapons\spv3\human\shotgun\shotgun")
(global object_definition smg_obj "cmt\weapons\spv3\human\smg\smg")
(global object_definition sr_obj "cmt\weapons\spv3\human\sniper_rifle\sniper_rifle")
(global object_definition ps_obj "cmt\weapons\spv3\human\pistol\pistol")





(global short grencount1 0)
(global short grencount2 0)

(global short grenlock 0)


(global long GX0 0)
(global long GX1 0)
(global long GX2 0)
(global long GX3 0)

(global short spawning 0)
(global short softlock 0)

(global short start 0)

(global short ai_debug 0)
(global short ally_debug 0)
(global short seed 0)
(global short tempint 0)
(global short tempint2 0)
(global short temp_shipcount 0)
(global short temp_ghostcount 0)
(global short temp_wraithcount 0)
(global short temp_bspindex 0)

(global unit dropship none)
(global unit grav none)
(global unit WRAITH none)
(global unit GHOST none)


(global short spawn_mode 0)
(global short vehicle_id 0)
(global short shipcount 0)
(global short wraithcount 0)
(global short ghostcount 0)

(global unit p1 none)

(script static unit p0 (unit (list_get (players) 0)))







;; Fuck me fuck me fuck me. Holy shit are there a lot of really convulted things going on in this map. 
;; I forced this game to do a lot of stuff it's simply not designed to do. These scripts are documented best I could.




;; so this first one is a temporary fix while I figure out how to kill vehicles without crashing the game.

(global boolean refresh false)


(script continuous refresher 

(sleep_until refresh)
(set refresh false)

(if (< -1 (unit_get_health ghosta))
(unit_kill ghosta)
)
(if (< -1 (unit_get_health ghostb))
(unit_kill ghostb)
)
(if (< -1 (unit_get_health ghostc))
(unit_kill ghostc)
)
(if (< -1 (unit_get_health ghostd))
(unit_kill ghostd)
)

(if (< -1 (unit_get_health sheea))
(unit_kill sheea)
)
(if (< -1 (unit_get_health sheeb))
(unit_kill sheeb)
)
(if (< -1 (unit_get_health sheec))
(unit_kill sheec)
)
(if (< -1 (unit_get_health sheed))
(unit_kill sheed)
)

(if (< -1 (unit_get_health mhoga))
(unit_kill mhoga)
)
(if (< -1 (unit_get_health mhogb))
(unit_kill mhogb)
)
(if (< -1 (unit_get_health mhogc))
(unit_kill mhogc)
)
(if (< -1 (unit_get_health mhogd))
(unit_kill mhogd)
)

(if (< -1 (unit_get_health wraitha))
(unit_kill wraitha)
)
(if (< -1 (unit_get_health wraithb))
(unit_kill wraithb)
)
)

;;The grenade setups below are to allow for recursive functions to be done, which I was able to avoid just about everywhere else.
;; Recursive functions are loops that repeat until a condition is met. They don't exist in blamscript, so we recreate them using
;; continuous scripts that start with the qualifying If statement at the end of each pass. When we meet the criteria, a (sleep -1) pauses
;; the script until it can be setup again and woken, ready to start from the top. We must be sure to reset the variables it uses before waking it,
;; so that when it restarts it's in the right setup. In the case of the grenades below, the variables are the 4 grenade counts GX0 GX1 GX2 GX3
;;There's no function that details how many of a specific grenade the player has. So we did some workaround. There are 4 starting
;; profiles in the scenario that each give a grenade. We use the (player_add_equipment) function with the boolean set false, and check
;; if the total grenade count has changed. if so we add 1 to the grenade count. If not, we move on to the next grenade type. 
;; This is used to reallocate the grenades that get taken away by the weapon chest scripts later on. We add up the grenades,
;; swap weapons (which deletes grenades) then add the grenades back afterwards. Yikes! Let's get to it then...



;;lol nevermind because opensauce




(script continuous GRENADE_WIZARD

	(sleep_until (= 1 grenlock) 5)


(set GX0 (unit_data_get_integer (p0) total_grenade_count[frag]))
(set GX1 (unit_data_get_integer (p0) total_grenade_count[plasma]))
(set GX2 (unit_data_get_integer (p0) total_grenade_count[custom2]))
(set GX3 (unit_data_get_integer (p0) total_grenade_count[custom3]))

(set grenlock 2)

(sleep_until (= 3 grenlock) 2)

(unit_data_set_integer (p0) total_grenade_count[frag] GX0)
(unit_data_set_integer (p0) total_grenade_count[plasma] GX1)
(unit_data_set_integer (p0) total_grenade_count[custom2] GX2)
(unit_data_set_integer (p0) total_grenade_count[custom3] GX3)


(set grenlock 0)

)









;;;;The following script sleeps until one of our ammo device_controls are activated.
;; this script will teleport ammo boxes of UNSC weapons to the player so that it appears they refilled
;; their ammo from the container. The controls are attached to ammo chest scenery items in the mr_resetti script.
;; this is because device_controls use special collision rules which only affect items like projectiles (maybe particles?), 
;; but the collision does not apply to the players themselves, so they can walk right through it


(script continuous AMMO_WIZARD





	(if  (= 1 (device_get_position ac1))
		(begin
			
			(objects_attach p1 "" a1 "")
			(objects_attach p1 "" a2 "")
			(objects_attach p1 "" a3 "")
			(objects_attach p1 "" a4 "")
			(objects_attach p1 "" a5 "")
			(objects_attach p1 "" a6 "")
			(objects_attach p1 "" a7 "")
			(objects_attach p1 "" a8 "")
			(objects_attach p1 "" a9 "")
			(objects_attach p1 "" a0 "")
			
			(objects_detach p1 a1)
			(objects_detach p1 a2)
			(objects_detach p1 a3)
			(objects_detach p1 a4)
			(objects_detach p1 a5)
			(objects_detach p1 a6)
			(objects_detach p1 a7)
			(objects_detach p1 a8)
			(objects_detach p1 a9)
			(objects_detach p1 a0)
			
			(sleep 1)
			
			(object_create_anew a0)
			(object_create_anew a1)
			(object_create_anew a2)
			(object_create_anew a3)
			(object_create_anew a4)
			(object_create_anew a5)
			(object_create_anew a6)
			(object_create_anew a7)
			(object_create_anew a8)
			(object_create_anew a9)
			
			(device_set_position ac1 0)
			
			
		)
		
	)


)

(script continuous GUN_WIZARD

	

	

	(if (= 1 (device_get_position gc1))			
		(begin
			(display_scripted_ui_widget "weaponmenu")
			(show_hud 0)
			(device_set_power gc1 0)
			
			
			(device_set_position gc1 0)
		)
	)

)

(script continuous SAVE_WIZARD
	(sleep (* 30 (* 60 3)))
	(sleep_until (game_safe_to_save) 5)
	(game_save_totally_unsafe)
)

(script continuous mr_resetti
	(sleep_until (= 1 start) 5)
	(if (!= (structure_bsp_index) temp_bspindex)
		(begin
			
			(set spawning 0)
			(set vehicle_id 0)
			(set spawn_mode 0)
			
			(set softlock 0)
			

			
			
			
			
			
			



			
			
			


			
			
				(if (= 0 (structure_bsp_index))
					(begin
					(objects_detach (AR1) ac1)
					(objects_detach (AR2) ac1)
					(objects_detach (AR3) ac1)
					(objects_detach (AR4) ac1)
					(objects_detach (AR5) ac1)
					(objects_attach (AR0) "" ac1 "")
					(objects_detach (AR0) ac1)
					)
				)
				(if (= 1 (structure_bsp_index))
					(begin
					(objects_detach (AR0) ac1)
					(objects_detach (AR2) ac1)
					(objects_detach (AR3) ac1)
					(objects_detach (AR4) ac1)
					(objects_detach (AR5) ac1)
					(objects_attach (AR1) "" ac1 "")
					(objects_detach (AR1) ac1)
					)
				)
				(if (= 2 (structure_bsp_index))
					(begin
					(objects_detach (AR0) ac1)
					(objects_detach (AR1) ac1)
					(objects_detach (AR3) ac1)
					(objects_detach (AR4) ac1)
					(objects_detach (AR5) ac1)
					(objects_attach (AR2) "" ac1 "")
					(objects_detach (AR2) ac1)
					)
				)
				
				(if (= 3 (structure_bsp_index))
					(begin
					(objects_detach (AR0) ac1)
					(objects_detach (AR1) ac1)
					(objects_detach (AR2) ac1)
					(objects_detach (AR4) ac1)
					(objects_detach (AR5) ac1)
					(objects_attach (AR3) "" ac1 "")
					(objects_detach (AR3) ac1)
					)
				)
				
				(if (= 4 (structure_bsp_index))
					(begin
					(objects_detach (AR0) ac1)
					(objects_detach (AR1) ac1)
					(objects_detach (AR2) ac1)
					(objects_detach (AR3) ac1)
					(objects_detach (AR5) ac1)
					(objects_attach (AR4) "" ac1 "")
					(objects_detach (AR4) ac1)
					)
				)
				
				(if (= 5 (structure_bsp_index))
					(begin
					(objects_detach (AR0) ac1)
					(objects_detach (AR1) ac1)
					(objects_detach (AR2) ac1)
					(objects_detach (AR3) ac1)
					(objects_detach (AR4) ac1)
					(objects_attach (AR5) "" ac1 "")
					(objects_detach (AR5) ac1)
					)
				)
				
				(if (= 0 (structure_bsp_index))
					(begin
					(objects_detach (GR1) gc1)
					(objects_detach (GR2) gc1)
					(objects_detach (GR3) gc1)
					(objects_detach (GR4) gc1)
					(objects_detach (GR5) gc1)
					(objects_attach (GR0) "" gc1 "")
					(objects_detach (GR0) gc1)
					)
				)
				(if (= 1 (structure_bsp_index))
					(begin
					(objects_detach (GR0) gc1)
					(objects_detach (GR2) gc1)
					(objects_detach (GR3) gc1)
					(objects_detach (GR4) gc1)
					(objects_detach (GR5) gc1)
					(objects_attach (GR1) "" gc1 "")
					(objects_detach (GR1) gc1)
					)
				)
				(if (= 2 (structure_bsp_index))
					(begin
					(objects_detach (GR0) gc1)
					(objects_detach (GR1) gc1)
					(objects_detach (GR3) gc1)
					(objects_detach (GR4) gc1)
					(objects_detach (GR5) gc1)
					(objects_attach (GR2) "" gc1 "")
					(objects_detach (GR2) gc1)
					)
				)
				
				(if (= 3 (structure_bsp_index))
					(begin
					(objects_detach (GR0) gc1)
					(objects_detach (GR1) gc1)
					(objects_detach (GR2) gc1)
					(objects_detach (GR4) gc1)
					(objects_detach (GR5) gc1)
					(objects_attach (GR3) "" gc1 "")
					(objects_detach (GR3) gc1)
					)
				)
				
				(if (= 4 (structure_bsp_index))
					(begin
					(objects_detach (GR0) gc1)
					(objects_detach (GR1) gc1)
					(objects_detach (GR2) gc1)
					(objects_detach (GR3) gc1)
					(objects_detach (GR5) gc1)
					(objects_attach (GR4) "" gc1 "")
					(objects_detach (GR4) gc1)
					)
				)
				
				(if (= 5 (structure_bsp_index))
					(begin
					(objects_detach (GR0) gc1)
					(objects_detach (GR1) gc1)
					(objects_detach (GR2) gc1)
					(objects_detach (GR3) gc1)
					(objects_detach (GR4) gc1)
					(objects_attach (GR5) "" gc1 "")
					(objects_detach (GR5) gc1)
					)
				)

			
		
		)
	)
	
	(if (= 1 spawning)
		(begin
			(sleep 30)
			(if (and (= 1 spawning ) (= 0 shipcount) )
				(begin
					(sleep 60)
					(if (and (= 1 spawning) (= 0 shipcount))
						(set spawning 0)
					)
				)
			)
		)
	)
	
	
	

	(set temp_bspindex (structure_bsp_index))
	(sleep 10)
)




(script continuous shipcounter
	(set temp_shipcount 0)
	(sleep 1)
	(if (< 0 (unit_get_health xship))
		(set temp_shipcount (+ temp_shipcount 1))
	)
	(sleep 1)
	(if (< 0  (unit_get_health yship))
		(set temp_shipcount (+ temp_shipcount 1))
	)
	(sleep 1)
	(if (< 0  (unit_get_health zship))
		(set temp_shipcount (+ temp_shipcount 1))
	)
	(sleep 1)
	(if (< 0  (unit_get_health uship))
		(set temp_shipcount (+ temp_shipcount 1))
	)
	(sleep 1)
	(if (< 0  (unit_get_health vship))
		(set temp_shipcount (+ temp_shipcount 1))
	)
	(sleep 1)
	(if (< 0  (unit_get_health wship))
		(set temp_shipcount (+ temp_shipcount 1))
	)
	(sleep 1)
	(set shipcount temp_shipcount)
	
)

(script continuous temp_ghostcounter

(set temp_ghostcount 0)
(if (< -1 (unit_get_health ghosta))
	(set temp_ghostcount (+ 1 temp_ghostcount))
)
(if (< -1 (unit_get_health ghostb))
	(set temp_ghostcount (+ 1 temp_ghostcount))
)
(if (< -1 (unit_get_health ghostc))
	(set temp_ghostcount (+ 1 temp_ghostcount))
)
(if (< -1 (unit_get_health ghostd))
	(set temp_ghostcount (+ 1 temp_ghostcount))
)
(set ghostcount temp_ghostcount)

)

(script continuous temp_wraithcounter

(set temp_wraithcount 0)
(if (< -1 (unit_get_health wraitha))
	(set temp_wraithcount (+ 1 temp_wraithcount))
)
(if (< -1 (unit_get_health wraithb))
	(set temp_wraithcount (+ 1 temp_wraithcount))
)
(set wraithcount temp_wraithcount)

)


(script continuous random_seed_obfuscator

	(player_action_test_reset)
		
	(sleep 5)

	(cond
		((player_action_test_look_relative_left)
			(begin
				(set seed (random_range 1 100))
				(set seed (random_range 1 1000))
				(set seed (random_range 1 172))
			)
		)
		
		((player_action_test_look_relative_up)
			(begin
				(set seed (random_range 1 45))
				(set seed (random_range 1 487))
			)
		)
		
		((player_action_test_look_relative_down)
			(begin
				(set seed (random_range 1 50))
				(set seed (random_range 1 500))
				(set seed (random_range 1 5000))
				(set seed (random_range 1 5))
			)
		)
		
		((player_action_test_look_relative_right)
			(begin
				(set seed (random_range 1 25))
				(set seed (random_range 1 250))
				(set seed (random_range 1 2500))
				(set seed (random_range 1 9001))
				(set seed (random_range 1 1337))
			)
		)
	
	
	
	)




)



(script continuous debugcounter
	(set ai_debug (+ (ai_living_count 1_headlong) (ai_living_count 1_terminal) (ai_living_count 1_ivory) (ai_living_count 1_parking) (ai_living_count 1_interior)))
	(set ally_debug (+ (ai_living_count 0_cybase) (ai_living_count 0_underpass) (ai_living_count 0_oldtown)))
)





(script static void spawn_dropship
	
	(cond
		((not (= 0 (unit_get_health uship)))
			(begin
				(object_destroy UCR)
				(object_destroy UCL)
				(object_destroy uship)
				
				(object_create uship)
				(object_create ucr)
				(object_create ucl)
				(object_create utr)
				(object_create utl)
				(object_create ug)
				(unit_close utr)
				(unit_close utl)
				(unit_close ug)
				
				(objects_attach uship "gravlift" ug "")
				(objects_attach uship "troop_door_right" utr "")
				(objects_attach uship "troop_door_left" utl "")
				(objects_attach uship "turret_door_left" ucr "")
				(objects_attach uship "turret_door_right" ucl "")
				
				(set dropship uship)
				(set grav ug)
			)
		)
	


		((not (= 0 (unit_get_health vship)))
			(begin
				(object_destroy vCR)
				(object_destroy vCL)
				(object_destroy vship)
				
				(object_create vship)
				(object_create vcr)
				(object_create vcl)
				(object_create vtr)
				(object_create vtl)
				(object_create vg)
				(unit_close vtr)
				(unit_close vtl)
				(unit_close vg)
				
				(objects_attach vship "gravlift" vg "")
				(objects_attach vship "troop_door_right" vtr "")
				(objects_attach vship "troop_door_left" vtl "")
				(objects_attach vship "turret_door_left" vcr "")
				(objects_attach vship "turret_door_right" vcl "")
				
				(set dropship vship)
				(set grav vg)
			)
		)
	

		((not (= 0 (unit_get_health wship)))
			(begin
				(object_destroy wCR)
				(object_destroy wCL)
				(object_destroy wship)
				
				(object_create wship)
				(object_create wcr)
				(object_create wcl)
				(object_create wtr)
				(object_create wtl)
				(object_create wg)
				(unit_close wtr)
				(unit_close wtl)
				(unit_close wg)
				
				(objects_attach wship "gravlift" wg "")
				(objects_attach wship "troop_door_right" wtr "")
				(objects_attach wship "troop_door_left" wtl "")
				(objects_attach wship "turret_door_left" wcr "")
				(objects_attach wship "turret_door_right" wcl "")
				
				(set dropship wship)
				(set grav wg)
			)
		)
	
	
	
		((not (= 0 (unit_get_health xship)))
			(begin
				(object_destroy xCR)
				(object_destroy xCL)
				(object_destroy xship)
				
				(object_create xship)
				(object_create xcr)
				(object_create xcl)
				(object_create xtr)
				(object_create xtl)
				(object_create xg)
				(unit_close xtr)
				(unit_close xtl)
				(unit_close xg)
				
				(objects_attach xship "gravlift" xg "")
				(objects_attach xship "troop_door_right" xtr "")
				(objects_attach xship "troop_door_left" xtl "")
				(objects_attach xship "turret_door_left" xcr "")
				(objects_attach xship "turret_door_right" xcl "")
				
				(set dropship xship)
				(set grav xg)
			)
		)
	
	
		((not (= 0 (unit_get_health yship)))
			(begin
				(object_destroy yCR)
				(object_destroy yCL)
				(object_destroy yship)
				
				(object_create yship)
				(object_create ycr)
				(object_create ycl)
				(object_create ytr)
				(object_create ytl)
				(object_create yg)
				(unit_close ytr)
				(unit_close ytl)
				(unit_close yg)
				
				(objects_attach yship "gravlift" yg "")
				(objects_attach yship "troop_door_right" ytr "")
				(objects_attach yship "troop_door_left" ytl "")
				(objects_attach yship "turret_door_left" ycr "")
				(objects_attach yship "turret_door_right" ycl "")
				
				(set dropship yship)
				(set grav yg)
			)
		)
	


		((not (= 0 (unit_get_health zship)))
			(begin
				(object_destroy zCR)
				(object_destroy zCL)
				(object_destroy zship)
				
				(object_create zship)
				(object_create zcr)
				(object_create zcl)
				(object_create ztr)
				(object_create ztl)
				(object_create zg)
				(unit_close ztr)
				(unit_close ztl)
				(unit_close zg)
				
				(objects_attach zship "gravlift" zg "")
				(objects_attach zship "troop_door_right" ztr "")
				(objects_attach zship "troop_door_left" ztl "")
				(objects_attach zship "turret_door_left" zcr "")
				(objects_attach zship "turret_door_right" zcl "")
				
				(set dropship zship)
				(set grav zg)
			)
		)
	)	
	
	
	(set softlock 0)
	
)



;;next we'll spawn one of two possible wraiths in the map. Basically a dupe of the above but FAR simplified with the lack of attachments.


(script static void spawn_wraith

		(set WRAITH none)
		
		
			(cond 
				((> 0 (unit_get_health wraitha))
				(begin
					(object_create_anew wraitha)
					(ai_place driver/ghost)
					(sleep 2)
					(vehicle_load_magic wraitha driver (ai_actors driver/ghost))
					(sleep_until (vehicle_test_seat_list wraitha "wraith-driver" (ai_actors driver/ghost)) 5)
					
					(set WRAITH wraitha)
				)
				)
				((> 0 (unit_get_health wraithb))
				(begin
					(object_create_anew wraithb)
					(ai_place driver/ghost)
					(sleep 2)
					(vehicle_load_magic wraithb driver (ai_actors driver/ghost))
					(sleep_until (vehicle_test_seat_list wraithb "wraith-driver" (ai_actors driver/ghost)) 5)
					
					(set WRAITH wraithb)
				)
				)
			)
			
		
		

		(set softlock 0)
)







(script static void spawn_ghost

		(set GHOST none)
		
			(cond 
				((> 0 (unit_get_health ghosta))
				(begin
					(object_create_anew ghosta)
					(ai_place driver/ghost)
					(sleep 2)
					(vehicle_load_magic ghosta driver (ai_actors driver/ghost))
					(sleep_until (vehicle_test_seat_list ghosta "G-driver" (ai_actors driver/ghost)) 5)
					(set GHOST ghosta)
				)
				)
				((> 0 (unit_get_health ghostb))
				(begin
					(object_create_anew ghostb)
					(ai_place driver/ghost)
					(sleep 2)
					(vehicle_load_magic ghostb driver (ai_actors driver/ghost))
					(sleep_until (vehicle_test_seat_list ghostb "G-driver" (ai_actors driver/ghost)) 5)
					(set GHOST ghostb)
				)
				)
				((> 0 (unit_get_health ghostc))
				(begin
					(object_create_anew ghostc)
					(ai_place driver/ghost)
					(sleep 2)
					(vehicle_load_magic ghostc driver (ai_actors driver/ghost))
					(sleep_until (vehicle_test_seat_list ghostc "G-driver" (ai_actors driver/ghost)) 5)
					(set GHOST ghostc)
				)
				)
				((> 0 (unit_get_health ghostd))
				(begin
					(object_create_anew ghostd)
					(ai_place driver/ghost)
					(sleep 2)
					(vehicle_load_magic ghostd driver (ai_actors driver/ghost))
					(sleep_until (vehicle_test_seat_list ghostd "G-driver" (ai_actors driver/ghost)) 5)
					(set GHOST ghostd)
				)
				)
				
			)
			
		
		

		(set softlock 0)
)


(script continuous ghost_smasher

	(sleep_until (= 0 spawning) 5)   ;; if Vehicle_ID = 0, we know that we're not trying to spawn anything, and we won't delete it halfway through creating it.
	
	(sleep 45) ;; give a second to make sure everyone has time to get in their vehicles or whatever.
	
	(if (and (< -1 (unit_get_health ghosta)) (not (vehicle_test_seat_list ghosta "G-driver" (ai_actors 2_mombasaghosts))))
		(begin
		(unit_kill ghosta)
		(object_destroy ghosta)
		)
	)
	
	(if (and (< -1 (unit_get_health ghostb)) (not (vehicle_test_seat_list ghostb "G-driver" (ai_actors 2_mombasaghosts))))
		(begin
		(unit_kill ghostb)
		(object_destroy ghostb)
		)
	)
	
	(if (and (< -1 (unit_get_health ghostc)) (not (vehicle_test_seat_list ghostc "G-driver" (ai_actors 2_mombasaghosts))))
		(begin
		(unit_kill ghostc)
		(object_destroy ghostc)
		)
	)
	
	(if (and (< -1 (unit_get_health ghostd)) (not (vehicle_test_seat_list ghostd "G-driver" (ai_actors 2_mombasaghosts))))
		(begin
		(unit_kill ghostd)
		(object_destroy ghostd)
		)
	)

)

(script continuous wraith_smasher

	(sleep_until (= 0 spawning) 5)   ;; if Vehicle_ID = 0, we know that we're not trying to spawn anything 
	
	(sleep 45) ;; give a second to make sure everyone has time to get in their vehicles or whatever.
	
	(if (and (< -1 (unit_get_health wraitha)) (not (vehicle_test_seat_list wraitha "wraith-driver" (ai_actors 2_mombasaghosts))))
		(begin
		(unit_kill wraitha)
		(object_destroy wraitha)
		)
	)
	
	(if (and (< -1 (unit_get_health wraithb)) (not (vehicle_test_seat_list wraithb "wraith-driver" (ai_actors 2_mombasaghosts))))
		(begin
		(unit_kill wraithb)
		(object_destroy wraithb)
		)
	)

)





;; the following script will be running to check if additional wraiths or ghosts need to be dropped into the level. Only the third and fourth BSP utilize vehicles.
;; by running the wraithcount after ghost count, we give preference to spawning a wraith when both of them are needed on the map. 
;; This uses some human logic to determine which vehicles to place. A cond returns ONLY the first true value.
;; So if the first value is true, none of the others are even looked at or checked. Perfect for something like the following:
;; What do we want? Ghosts, then wraiths. There shouldn't be 4 ghosts and no wraiths, there shouldn't be 2 wraiths and no ghosts.
;; So we first check if there's less than 2 ghosts. If so we spawn some. Always have ghosts on the map.
;; Then we check for at least one wraith. If there are 0 we spawn a wraith. Don't want 3 ghosts and no wraith.
;; Then we check for 3 or more ghosts. If there's only 2 or less ghosts, and at least 1 wraith, we spawn more ghosts.
;; As a backup, if there are more than 1 wraith and more than 2 ghosts, don't spawn anything at all. 

(script continuous do_i_need_a_car 

	(sleep_until (= 0 vehicle_id) 5)
	(sleep 15) 
	
	(if (or (= 2 (structure_bsp_index)) (= 4 (structure_bsp_index)) )
		(begin
			(cond 
							((> 2 ghostcount)
								(set vehicle_id 1)
							)
							((= 0 wraithcount)
								(set vehicle_id 2)
							)
							((> 3 ghostcount)
								(set vehicle_id 1)
							)
						
			)
		)
	)
	(if (= 3 (structure_bsp_index))
		(begin
			(cond 
							((> 2 ghostcount)
								(set vehicle_id 1)
							)	
			)
		)
	)
	
	
	(if (and (< 0 wraithcount) (< 2 ghostcount))
		(set vehicle_id 0)
	)
	
	(if (or (= 0 (structure_bsp_index)) (= 1 (structure_bsp_index)) (= 5 (structure_bsp_index)))
		(set vehicle_id 0)
	)
	
)





;; Our spawn system creates a single script that spawns AI in a shared location. The AI are then migrated to local AI which populate each indivdual BSP
;; the spawn script for allied marines is below. We call for the AI in scripts beneath it. The spawn script is global, the scripts that call it are all local.
;; The scripts beneath wait for the BSP to be valid, for the AI to be out of reinforcements, and for the player to be near that AI's section.
;; Then we run the spawn_ai script and wait for it to create our encounter. After so many ticks, the local script migrates the AI and begins the dropship.



		;;the following script is the big one. It controls the main CSPAWN squad that is shared between ALL BSP structures. It is a modular setup with 1 spawn per AI type, with the number of AI being entirely
		;;controlled by the script itself. This allows for full control at all times with the complete range of AI available, without having to setup spawns for each individual encounter. The main CSPAWN A.I. group
		;;is then migrated using ai_migrate to the actual encounter that they will be acting as. Here she is;


(script static void spawn_ai
		(set tempint (random_range 1 11))

		
	
		
		(if (= 0 spawn_mode)  ;; this is a trigger we use when we want to spawn a smaller encounter. If set to 1 we only spawn the small group.
			(begin				
				(ai_place cspawn/s-pp)
				(ai_place cspawn/s-pp)	
				(ai_place cspawn/g-pp)  ;;; these always spawn. By placing more up here, we lessen potential variety 
				(ai_place cspawn/g+pp)	;;; but allow for a "half spawn" of the stronger characters below.
				
				
				
				(if (= (game_difficulty_get) hard) 
					(begin
						(ai_place cspawn/j-pp)				
						(ai_place cspawn/j-pp)
						(ai_place cspawn/e-pr)
						(ai_place cspawn/gund)		;; these will also spawn if the game is on heroic
					)
				)
				(if (= (game_difficulty_get) impossible) 
					(begin
						(ai_place cspawn/g+pp)
						(ai_place cspawn/j-pp)				
						(ai_place cspawn/j-pp)
						(ai_place cspawn/e+cb)
						(ai_place cspawn/s+nd)			;; or these will if set to legendary. 
						(ai_place cspawn/s+nd)
					)
				)	
			)
		)

		(if (= tempint 1)
			(begin
				(ai_place cspawn/e-pr)
				 (ai_place cspawn/e+pr)
				(ai_place cspawn/g-pp)
				(ai_place cspawn/j-pp)
				(ai_place cspawn/j+sh)
			)
		)

		(if (= tempint 2)
			(begin
				(ai_place cspawn/BF-BP)
				(ai_place cspawn/BF-BP)
				(ai_place cspawn/BL-CB)
				(ai_place cspawn/s+nd)
				(ai_place cspawn/jSCB)
				(ai_place cspawn/j-pp)
			)
		)

		(if (= tempint 3)
			(begin
				(ai_place cspawn/BL-CB)
				(ai_place cspawn/BF+BR)
				(ai_place cspawn/Bf-BP)
				(ai_place cspawn/GUND)
				(ai_place cspawn/j-pp)
				(ai_place cspawn/jSCB)
			)
		)

		(if (= tempint 4)
			(begin
				(ai_place cspawn/e+CB)
				(ai_place cspawn/e-pr)
				(ai_place cspawn/g+pp)
				(ai_place cspawn/S-PP)
				(ai_place cspawn/S+ND)
			)
		)


		(if (= tempint 5)
			(begin
				(ai_place cspawn/BL+BS)
				(ai_place cspawn/BF+BR)
				(ai_place cspawn/GUND)
				(ai_place cspawn/GUND)				
				(ai_place cspawn/s+nd)
				
			)
		)

		(if (= tempint 6)
			(begin
				(ai_place cspawn/BL-CB)
				(ai_place cspawn/BF-BP)
				(ai_place cspawn/BF-BP)
				(ai_place cspawn/s+nd)
				(ai_place cspawn/j-pp)
				
			)
		)

		(if (= tempint 7)
			(begin
				(ai_place cspawn/e+CB)
				(ai_place cspawn/e+pr)
				(ai_place cspawn/g-pp)
				(ai_place cspawn/j+pp)
				(ai_place cspawn/j+sh)
			)
		)

		(if (= tempint 8)
			(begin
				(ai_place cspawn/e+pr)
				(ai_place cspawn/e-pr)
				(ai_place cspawn/g+pp)
				(ai_place cspawn/jSCB)
				(ai_place cspawn/jSCB)
			)
		)

		(if (= tempint 9)
			(begin
				(ai_place cspawn/e+CB)
				(ai_place cspawn/e-pr)
				(ai_place cspawn/e-pr)
				(ai_place cspawn/j+pp)
			)
		)

		(if (= tempint 10)
			(begin
				(ai_place cspawn/EUES)
				(ai_place cspawn/e+CB)
				(ai_place cspawn/g+pp)
				(ai_place cspawn/j+sh)
				(ai_place cspawn/j+sh)
			)
		)

	(set softlock 0)
)



;;For marines, we wait until the player has left that zone and then spawn the AI, migrate the AI, and then run (ai_teleport_to_starting_location) to move them to the BSP.
;; the spawn points are placed so that the player cannot see them unless they are inside that zone. This makes sure that AI won't ever pop-up in front of the player's view.
;;For Covenant, We create 10 squads that can be dropped, to be sure there are a proper mix and setup of the characters. We want balance in each squad the player fights against.
;;Since the marines are for support, balance isn't important. There are no power weapons, so we simply pick one at random repeatedly until we have 6, and then migrate them to the local BSP.




(script continuous hspawner    ;; as hspawner is a continuous, in our startup script    "Preheat"    we put it to sleep remotely.
		(if (> (ai_living_count hspawn) 3)
			(sleep -1)  ;; if there are more than 3 marines, the script sleeps indefinitely.
			(begin		;; if there are not more than 3 marines, it spawns one at random.
			

				(set tempint (random_range 1 10))
				
				(if (= tempint 1)
					(ai_place hspawn/MAR))
				(if (= tempint 2)
					(ai_place hspawn/MBR))
				(if (= tempint 3)
					(ai_place hspawn/OAR))
				(if (= tempint 4)
					(ai_place hspawn/OBR))
				(if (= tempint 5)
					(ai_place hspawn/M++))
				(if (= tempint 6)
					(ai_place hspawn/PSM))
				(if (= tempint 7)
					(ai_place hspawn/PSG))
				(if (= tempint 8)
					(ai_place hspawn/PHP))
				(if (= tempint 9)
					(ai_place hspawn/FMAR))
			)
		)
		
		;; because the script uses the (sleep -1) command in the true return of an IF statement, when the script is woken it will return back to the IF and run again.
		;; The ELSE half is the (begin script, which randomly spawns one AI and then waits to see if there are 3.
		;; the scripts below are waiting for there to be 3 AI which they then replace.
		
		
)

(script dormant escape
			(device_set_power gc1 1)
			(show_hud 1)
	

)

(script dormant health_pack
			(device_set_power gc1 1)
			
			
			(objects_attach p1 "" a0 "")
			(objects_detach p1 a0)
			(sleep 2)
			(object_create_anew a0)
			(show_hud 1)
			
)

(script dormant spawn_ps

	(show_hud 1)
			
	(if (not (unit_has_weapon p1 ps_obj))
		(begin
			(set grenlock 1)
			(sleep_until (= 2 grenlock) 5)
			
			(sleep 1)
			(player_add_equipment p1 blank true)
			
			(set grenlock 3)
			(object_create_anew pistol)
			(objects_attach p1 "" pistol "")
			(sleep 1)
			(objects_detach p1 pistol)
			
			
					(device_set_power gc1 1)
					
		)
		(begin
					(device_set_power gc1 1)
					
		)
		
	)
)

(script dormant spawn_ar

	(show_hud 1)
	
	(if (not (unit_has_weapon p1 ar_obj))
		(begin
			(set grenlock 1)
			(sleep_until (= 2 grenlock) 5)
			
			(sleep 1)
			(player_add_equipment p1 blank true)
			
			(set grenlock 3)
			(object_create_anew assault_rifle)
			(objects_attach p1 "" assault_rifle "")
			(sleep 1)
			(objects_detach p1 assault_rifle)
			
			
					(device_set_power gc1 1)
					
		)
		(begin
					(device_set_power gc1 1)
					
		)
	)
)


(script dormant spawn_br

	(show_hud 1)
	(if (not (unit_has_weapon p1 br_obj))
		(begin	
			(set grenlock 1)
			(sleep_until (= 2 grenlock) 5)
			
			(sleep 1)
			(player_add_equipment p1 blank true)
			
			(set grenlock 3)
			(object_create_anew battle_rifle)
			(objects_attach p1 "" battle_rifle "")
			(sleep 1)
			(objects_detach p1 battle_rifle)
			
			
					(device_set_power gc1 1)
					
		)
		(begin
					(device_set_power gc1 1)
					
		)
	)
)


(script dormant spawn_sg


	(show_hud 1)
	(if (not (unit_has_weapon p1 sg_obj))
		(begin	
			(set grenlock 1)
			(sleep_until (= 2 grenlock) 5)
			
			(sleep 1)
			(player_add_equipment p1 blank true)
			
			(set grenlock 3)
			(object_destroy shotgun)
			(object_create_anew shotgun)
			(objects_attach p1 "" shotgun "")
			(sleep 1)
			(objects_detach p1 shotgun)
			
			
					(device_set_power gc1 1)
					
		)
		(begin
					(device_set_power gc1 1)
					
		)
	)
)


(script dormant spawn_smg

	(show_hud 1)
	(if (not (unit_has_weapon p1 smg_obj))
		(begin	
			(set grenlock 1)
			(sleep_until (= 2 grenlock) 5)
			
			(sleep 1)
			(player_add_equipment p1 blank true)
			
			(set grenlock 3)
			(object_create_anew smg)
			(objects_attach p1 "" smg "")
			(sleep 1)
			(objects_detach p1 smg)
			
			
					(device_set_power gc1 1)
					
		)
		(begin
					(device_set_power gc1 1)
					
		)
	)
)


(script dormant spawn_sr

	(show_hud 1)
	(if (not (unit_has_weapon p1 sr_obj))
		(begin	
			(set grenlock 1)
			(sleep_until (= 2 grenlock) 5)
			
			(sleep 1)
			(player_add_equipment p1 blank true)
			
			(set grenlock 3)
			(object_create_anew sniper_rifle)
			(objects_attach p1 "" sniper_rifle "")
			(sleep 1)
			(objects_detach p1 sniper_rifle)
			
			
					(device_set_power gc1 1)
					
		)
		(begin
					(device_set_power gc1 1)
					
		)
	)
)

(script dormant spawn_dr

	(show_hud 1)
	
	(if (not (unit_has_weapon p1 dr_obj))
		(begin
			(set grenlock 1)
			(sleep_until (= 2 grenlock) 5)
			
			(sleep 1)
			(player_add_equipment p1 blank true)
			
			(set grenlock 3)
			(object_create_anew dmr)
			(objects_attach p1 "" dmr "")
			(sleep 1)
			(objects_detach p1 dmr)
			
			
					(device_set_power gc1 1)
					
		)
		(begin
					(device_set_power gc1 1)
					
		)
	)		
)


	
	
(script startup Preheat
	
		
		(sleep -1 hspawner)   ;; immediately put the hspawner to sleep, so that it starts in the OFF position.
		(if (= 1 (get_digital_forward_throttle 2))
			(begin
				(set_digital_forward_throttle 2 0)
				(core_load)			
			)
		)
		
		(objects_attach (GR0) "" gc1 "")
		(objects_attach (AR0) "" ac1 "")
		(objects_detach (GR0) gc1)
		(objects_detach (AR0) ac1)
		
		(object_create_anew 0_grenade)
		(object_create_anew 1_grenade)
		(object_create_anew 2_grenade)
		(object_create_anew 3_grenade)
		
		
		(set p1 (unit (list_get (players) 0)))
		(ai_allegiance human player)
		(set developer_mode 0)
		(ai_follow_target_players 0_cybase)
		(ai_follow_target_players 0_underpass)
		(ai_follow_target_players 0_oldtown)
		(ai_follow_target_players 1_headlong)
		(ai_follow_target_players 1_terminal)
		(ai_follow_target_players 1_tower)
		(ai_follow_target_players 2_mombasamarine)
		(ai_follow_target_players 2_chronomarine)
		(ai_follow_target_players 3_marinefront)
		(ai_follow_target_players 3_marinemid)
		(ai_follow_target_players 3_marineback)
		(ai_follow_target_players 4_marineA)
		(ai_follow_target_players 4_marineB)
		(ai_follow_target_players 4_marineC)
		(ai_follow_target_players 5_marineA)
		(ai_follow_target_players 5_marineB)
		
		
		(set start 1)
	
)	


(script continuous sp_0turf
	(sleep -1)
		
				(vehicle_unload ug)
				(sleep 10)
				(object_destroy UCR)
				(object_destroy UCL)
				(object_destroy ug)
				(object_destroy utl)
				(object_destroy utr)
				(object_destroy uship)
				
				(object_create uship)
				(object_create ucr)
				(object_create ucl)
				(object_create utr)
				(object_create utl)
				(object_create ug)
				(unit_close utr)
				(unit_close utl)
				(unit_close ug)
				
				(objects_attach uship "gravlift" ug "")
				(objects_attach uship "troop_door_right" utr "")
				(objects_attach uship "troop_door_left" utl "")
				(objects_attach uship "turret_door_left" ucr "")
				(objects_attach uship "turret_door_right" ucl "")

	
	
	
	(set softlock 1)
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	

	
	
	
	(vehicle_load_magic ug "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 0_turf/s)
	(set spawning 0)
	
	(set tempint (random_range 1 3))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport uship 0_oldtown)
			(recording_play uship 0_oldtownturf)
			
			
			
			(sleep_until (> 800 (recording_time uship)) 5)
			(unit_open ug)
			(sleep 30)
			(ai_braindead 0_turf 0)
			(vehicle_unload ug "")
			(ai_attack 0_turf)
			(sleep_until (= 0 (recording_time uship)) 5)
			
				(object_destroy uship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport uship 0_turf)
			(recording_play uship 0_turf)
			
			
			
			(sleep_until (> 910 (recording_time uship)) 5)
			(unit_open ug)
			(sleep 30)
			(ai_braindead 0_turf 0)
			(vehicle_unload ug "")
			(ai_attack 0_turf)
			(sleep_until (= 0 (recording_time uship)) 5)
			
				(object_destroy uship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 0_turf/s 0_turf/c)
					
)	


(script continuous sp_0courtyard
	(sleep -1)
		
				(vehicle_unload vg)
				(sleep 10)
				(object_destroy vCR)
				(object_destroy vCL)
				(object_destroy vg)
				(object_destroy vtl)
				(object_destroy vtr)
				(object_destroy vship)
				
				(object_create vship)
				(object_create vcr)
				(object_create vcl)
				(object_create vtr)
				(object_create vtl)
				(object_create vg)
				(unit_close vtr)
				(unit_close vtl)
				(unit_close vg)
				
				(objects_attach vship "gravlift" vg "")
				(objects_attach vship "troop_door_right" vtr "")
				(objects_attach vship "troop_door_left" vtl "")
				(objects_attach vship "turret_door_left" vcr "")
				(objects_attach vship "turret_door_right" vcl "")
				
	(set softlock 1)
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	
	
	
	
	(vehicle_load_magic vg "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 0_courtyard/s)
	(set spawning 0)
	
	(set tempint (random_range 1 3))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport vship 0_courtyardA)
			(recording_play vship 0_courtyardA)
			
			
			
			(sleep_until (> 735 (recording_time vship)) 5)
			(unit_open vg)
			(sleep 30)
			(ai_braindead 0_courtyard 0)
			(vehicle_unload vg "")
			(ai_attack 0_courtyard)
			(sleep_until (= 0 (recording_time vship)) 5)
			
				(object_destroy vship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport vship 0_courtyardB)
			(recording_play vship 0_courtyardB)
			
			
			
			(sleep_until (> 685 (recording_time vship)) 5)
			(unit_open vg)
			(sleep 30)
			(ai_braindead 0_courtyard 0)
			(vehicle_unload vg "")
			(ai_attack 0_courtyard)
			(sleep_until (= 0 (recording_time vship)) 5)
			
				(object_destroy vship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 0_courtyard/s 0_courtyard/c)
					
)	



(script continuous sp_0jalley

	(sleep -1)
		
				(vehicle_unload wg)
				(sleep 10)
				(object_destroy wCR)
				(object_destroy wCL)
				(object_destroy wg)
				(object_destroy wtl)
				(object_destroy wtr)
				(object_destroy wship)
				
				
				(object_create wship)
				(object_create wcr)
				(object_create wcl)
				(object_create wtr)
				(object_create wtl)
				(object_create wg)
				(unit_close wtr)
				(unit_close wtl)
				(unit_close wg)
				
				(objects_attach wship "gravlift" wg "")
				(objects_attach wship "troop_door_right" wtr "")
				(objects_attach wship "troop_door_left" wtl "")
				(objects_attach wship "turret_door_left" wcr "")
				(objects_attach wship "turret_door_right" wcl "")
				
	(set softlock 1)
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	

	
	
	
	
	(vehicle_load_magic wg "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 0_jalley/s)
	(set spawning 0)
	
	
	(set tempint (random_range 1 3))
	
	(if (= 1 tempint) 
		(begin	
	
			(object_teleport wship 0_overpass)
			(recording_play wship 0_overpass)
			
			
			
			(sleep_until (> 705 (recording_time wship)) 5)
			(unit_open wg)
			(sleep 30)
			(ai_braindead 0_jalley 0)
			(vehicle_unload wg "")
			(ai_attack 0_jalley)
			(sleep_until (= 0 (recording_time wship)) 5)
			
				(object_destroy wship)
				
				
			(sleep 15)
		
		)
	)
	(if (= 2 tempint) 
		(begin	
			
			(object_teleport wship 0_oldtown)
			(recording_play wship 0_oldtown)
			
			
			
			(sleep_until (> 830 (recording_time wship)) 5)
			(unit_open wg)
			(sleep 30)
			(ai_braindead 0_jalley 0)
			(vehicle_unload wg "")
			(ai_attack 0_jalley)
			(sleep_until (= 0 (recording_time wship)) 5)
			
				(object_destroy wship)
				
				
			(sleep 15)
		
		)
	)
	
	(ai_migrate 0_jalley/s 0_jalley/c)
					
)	



(script continuous sp_1headlong

	(sleep -1)
		
	
				(vehicle_unload ug)
				(sleep 10)
				(object_destroy UCR)
				(object_destroy UCL)
				(object_destroy ug)							
				(object_destroy utl)
				(object_destroy utr)
				(object_destroy uship)	
				
				(object_create uship)
				(object_create ucr)
				(object_create ucl)
				(object_create utr)
				(object_create utl)
				(object_create ug)
				(unit_close utr)
				(unit_close utl)
				(unit_close ug)
				
				(objects_attach uship "gravlift" ug "")
				(objects_attach uship "troop_door_right" utr "")
				(objects_attach uship "troop_door_left" utl "")
				(objects_attach uship "turret_door_left" ucr "")
				(objects_attach uship "turret_door_right" ucl "")

	(set softlock 1)
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	

	
	
	
	(vehicle_load_magic ug "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 1_headlong/s)
	(set spawning 0)
	
	(set tempint (random_range 1 3))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport uship 1_headlonga)
			(recording_play uship 1_headlonga)
			
			
			
			(sleep_until (> 715 (recording_time uship)) 5)
			(unit_open ug)
			(sleep 30)
			(ai_braindead 1_headlong 0)
			(vehicle_unload ug "")
			(ai_attack 1_headlong)
			(sleep_until (= 0 (recording_time uship)) 5)
			
				(object_destroy uship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport uship 1_headlongb)
			(recording_play uship 1_headlongb)
			
			
			
			(sleep_until (> 905 (recording_time uship)) 5)
			(unit_open ug)
			(sleep 30)
			(ai_braindead 1_headlong 0)
			(vehicle_unload ug "")
			(ai_attack 1_headlong)
			(sleep_until (= 0 (recording_time uship)) 5)
			
				(object_destroy uship)
				
				
			(sleep 15)
		)
	)
		
	(ai_migrate 1_headlong/s 1_headlong/c)
	
)	


(script continuous sp_1terminal

	(sleep -1)
		
				(vehicle_unload vg)
				(sleep 10)
				(object_destroy vCR)
				(object_destroy vCL)
				(object_destroy vg)
				(object_destroy vtl)
				(object_destroy vtr)
				(object_destroy vship)
				
				(object_create vship)
				(object_create vcr)
				(object_create vcl)
				(object_create vtr)
				(object_create vtl)
				(object_create vg)
				(unit_close vtr)
				(unit_close vtl)
				(unit_close vg)
				
				(objects_attach vship "gravlift" vg "")
				(objects_attach vship "troop_door_right" vtr "")
				(objects_attach vship "troop_door_left" vtl "")
				(objects_attach vship "turret_door_left" vcr "")
				(objects_attach vship "turret_door_right" vcl "")
				
				
	(set softlock 1)
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	


	
	
	(vehicle_load_magic vg "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 1_terminal/s)
	(set spawning 0)
	
	(set tempint (random_range 1 3))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport vship 1_terma)
			(recording_play vship 1_terma)
			
			
			
			(sleep_until (> 870 (recording_time vship)) 5)
			(unit_open vg)
			(sleep 30)
			(ai_braindead 1_terminal 0)
			(vehicle_unload vg "")
			(ai_attack 1_terminal)
			(sleep_until (= 0 (recording_time vship)) 5)
			
				(object_destroy vship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport vship 1_termb)
			(recording_play vship 1_termb)
			
			
			
			(sleep_until (> 1280 (recording_time vship)) 5)
			(unit_open vg)
			(sleep 30)
			(ai_braindead 1_terminal 0)
			(vehicle_unload vg "")
			(ai_attack 1_terminal)
			(sleep_until (= 0 (recording_time vship)) 5)
			
				(object_destroy vship)
				
				
			(sleep 15)
		)
	)
	
	
	(ai_migrate 1_terminal/s 1_terminal/c)
					
)	

;;;;;

;;;;

;; BSP 2

;;;;;;

;;;;;
			

(script continuous sp_2mombasarear

	(sleep -1)
		
	
				(vehicle_unload ug)
				(sleep 10)
				(object_destroy UCR)
				(object_destroy UCL)
				(object_destroy ug)
				(object_destroy utl)
				(object_destroy utr)
				(object_destroy uship)
				
				(object_create uship)
				(object_create ucr)
				(object_create ucl)
				(object_create utr)
				(object_create utl)
				(object_create ug)
				
				(objects_attach uship "gravlift" ug "")
				(objects_attach uship "troop_door_right" utr "")
				(objects_attach uship "troop_door_left" utl "")
				(objects_attach uship "turret_door_left" ucr "")
				(objects_attach uship "turret_door_right" ucl "")

	
	
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
		
	(cond 
					((= 0 vehicle_id)
						(sleep 1)
					)
					((= 1 vehicle_id)
						(begin
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach uship "small_cargo01" GHOST "" )
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach uship "small_cargo02" GHOST "")
							(set vehicle_id 0)
							(ai_migrate driver/ghost 2_mombasaghosts)
						)
					)
					((= 2 vehicle_id)	
						(begin
							(set softlock 1)
							(spawn_wraith)
							(sleep_until (= 0 softlock) 5)
							(objects_attach uship "large_cargo" WRAITH "" )
							(ai_migrate driver/ghost 2_mombasaghosts)
							(set vehicle_id 0)
						)
					)
	)
	
	
	
	
	
	(vehicle_load_magic ug "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 2_mombasarear/s)
	(set spawning 0)
	
	
	(set tempint (random_range 1 4))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport uship 2_newmombasaA1)
			(recording_play uship 2_newmombasaA1)
			
			
			
			(sleep_until (> 955 (recording_time uship)) 5)
			(unit_open ug)
			(sleep 30)
			(ai_braindead 2_mombasarear 0)
			(vehicle_unload ug "")
			
			(objects_detach uship wraitha)
			(objects_detach uship wraithb)
			
			(objects_detach uship ghosta)
			(objects_detach uship ghostb)
			(objects_detach uship ghostc)
			(objects_detach uship ghostd)
			
			(ai_attack 2_newmombasa)
			(sleep_until (= 0 (recording_time uship)) 5)
			
				(object_destroy uship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport uship 2_newmombasaA)
			(recording_play uship 2_newmombasaA2)
			
			
			
			(sleep_until (> 965 (recording_time uship)) 5)
			(unit_open ug)
			(sleep 30)
			(ai_braindead 2_mombasarear 0)
			(vehicle_unload ug "")
			
			(objects_detach uship wraitha)
			(objects_detach uship wraithb)
			
			(objects_detach uship ghosta)
			(objects_detach uship ghostb)
			(objects_detach uship ghostc)
			(objects_detach uship ghostd)
			
			(ai_attack 2_newmombasa)
			(sleep_until (= 0 (recording_time uship)) 5)
			
				(object_destroy uship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 3 tempint) 
		(begin
			(object_teleport uship 2_newmombasaA)
			(recording_play uship 2_newmombasaA3)
			
			
			
			(sleep_until (> 1190 (recording_time uship)) 5)
			(unit_open ug)
			(sleep 30)
			(ai_braindead 2_mombasarear 0)
			(vehicle_unload ug "")
			
			(objects_detach uship wraitha)
			(objects_detach uship wraithb)
			
			(objects_detach uship ghosta)
			(objects_detach uship ghostb)
			(objects_detach uship ghostc)
			(objects_detach uship ghostd)
			
			(ai_attack 2_newmombasa)
			(sleep_until (= 0 (recording_time uship)) 5)
			
				(object_destroy uship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 2_mombasarear/s 2_mombasarear/c)
					
)


(script continuous sp_2newmombasa
		
	(sleep -1)
	
				(vehicle_unload vg)
				(sleep 10)
				(object_destroy vCR)
				(object_destroy vCL)
				(object_destroy vg)
				(object_destroy vtl)
				(object_destroy vtr)
				(object_destroy vship)
				
				(object_create vship)
				(object_create vcr)
				(object_create vcl)
				(object_create vtr)
				(object_create vtl)
				(object_create vg)
				(unit_close vtr)
				(unit_close vtl)
				(unit_close vg)
				
				(objects_attach vship "gravlift" vg "")
				(objects_attach vship "troop_door_right" vtr "")
				(objects_attach vship "troop_door_left" vtl "")
				(objects_attach vship "turret_door_left" vcr "")
				(objects_attach vship "turret_door_right" vcl "")
				
	(set softlock 1)
	
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
	
	
	
	(cond 
					((= 0 vehicle_id)
						(sleep 1)
					)
					((= 1 vehicle_id)
						(begin
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(if (!= GHOST none)
								(begin
									(objects_attach vship "small_cargo01" GHOST "" )
									(ai_migrate driver/ghost 2_mombasaghosts)
								)
							)
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(if (!= GHOST none)
								(begin
									(objects_attach vship "small_cargo02" GHOST "")
									(ai_migrate driver/ghost 2_mombasaghosts)
								)
							)
							(set vehicle_id 0)
						)
					)
					((= 2 vehicle_id)	
						(begin
							(set softlock 1)
							(spawn_wraith)
							(sleep_until (= 0 softlock) 5)
							(if (!= WRAITH none)
								(begin
									(objects_attach vship "large_cargo" WRAITH "" )
									(ai_migrate driver/ghost 2_mombasaghosts)
								)
							)
							(set vehicle_id 0)
						)
					)
	)
	
	
	
	
	
	(vehicle_load_magic vg "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 2_newmombasa/s)
	(set spawning 0)
	
	(set tempint (random_range 1 4))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport vship 2_newmombasaB)
			(recording_play vship 2_newmombasaB1)
			
			
			
			(sleep_until (> 965 (recording_time vship)) 5)
			(unit_open vg)
			(sleep 30)
			(ai_braindead 2_newmombasa 0)
			(vehicle_unload vg "")
			
			(objects_detach vship wraitha)
			(objects_detach vship wraithb)
			
			(objects_detach vship ghosta)
			(objects_detach vship ghostb)
			(objects_detach vship ghostc)
			(objects_detach vship ghostd)
			
			
			(ai_attack 2_mombasarear)
			(sleep_until (= 0 (recording_time vship)) 5)
			
				(object_destroy vship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport vship 2_newmombasaB)
			(recording_play vship 2_newmombasaB2)
			
			
			
			(sleep_until (> 1280 (recording_time vship)) 5)
			(unit_open vg)
			(sleep 30)
			(ai_braindead 2_newmombasa 0)
			(vehicle_unload vg "")
			
			(objects_detach vship wraitha)
			(objects_detach vship wraithb)
			
			(objects_detach vship ghosta)
			(objects_detach vship ghostb)
			(objects_detach vship ghostc)
			(objects_detach vship ghostd)
			
			
			(ai_attack 2_mombasarear)
			(sleep_until (= 0 (recording_time vship)) 5)
			
				(object_destroy vship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 3 tempint) 
		(begin
			(object_teleport vship 2_newmombasaB)
			(recording_play vship 2_newmombasaB3)
			
			
			
			(sleep_until (> 780 (recording_time vship)) 5)
			(unit_open vg)
			(sleep 30)
			(ai_braindead 2_newmombasa 0)
			(vehicle_unload vg "")
			
			(objects_detach vship wraitha)
			(objects_detach vship wraithb)
			
			(objects_detach vship ghosta)
			(objects_detach vship ghostb)
			(objects_detach vship ghostc)
			(objects_detach vship ghostd)
			
			
			(ai_attack 2_mombasarear)
			(sleep_until (= 0 (recording_time vship)) 5)
			
				(object_destroy vship)
				
				
			(sleep 15)
		)
	)
	
	
	(ai_migrate 2_newmombasa/s 2_newmombasa/c)
					
)


(script continuous sp_2loadingbay

	(sleep -1)

		
				(vehicle_unload wg)
				(sleep 10)
				(object_destroy wCR)
				(object_destroy wCL)
				(object_destroy wg)
				(object_destroy wtl)
				(object_destroy wtr)
				(object_destroy wship)
				
				(object_create wship)
				(object_create wcr)
				(object_create wcl)
				(object_create wtr)
				(object_create wtl)
				(object_create wg)
				(unit_close wtr)
				(unit_close wtl)
				(unit_close wg)
				
				(objects_attach wship "gravlift" wg "")
				(objects_attach wship "troop_door_right" wtr "")
				(objects_attach wship "troop_door_left" wtl "")
				(objects_attach wship "turret_door_left" wcr "")
				(objects_attach wship "turret_door_right" wcl "")	
				
	(set softlock 1)	
	
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
	
	
	

	
	
	(cond 
					((= 0 vehicle_id)
						(sleep 1)
					)
					((= 1 vehicle_id)
						(begin
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach wship "small_cargo01" GHOST "" )
							(ai_migrate driver/ghost 2_mombasaghosts)
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach wship "small_cargo02" GHOST "")
							(ai_migrate driver/ghost 2_mombasaghosts)
							(set vehicle_id 0)
							
						)
					)
					((= 2 vehicle_id)	
						(begin
							(set softlock 1)
							(spawn_wraith)
							(sleep_until (= 0 softlock) 5)
							(objects_attach wship "large_cargo" WRAITH "" )
							(ai_migrate driver/ghost 2_mombasaghosts)
							(set vehicle_id 0)
						)
					)
	)
	
	
	
	
	
	(vehicle_load_magic wg "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 2_loadingbay/s)
	(set spawning 0)
	
	(set tempint (random_range 1 3))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport wship 2_loading)
			(recording_play wship 2_loading1)
			
			
			
			(sleep_until (> 1190 (recording_time wship)) 5)
			(unit_open wg)
			(sleep 30)
			(ai_braindead 2_loadingbay 0)
			(vehicle_unload wg "")
			
			(objects_detach wship wraitha)
			(objects_detach wship wraithb)
			
			(objects_detach wship ghosta)
			(objects_detach wship ghostb)
			(objects_detach wship ghostc)
			(objects_detach wship ghostd)
			
			
			(ai_attack 2_loadingbay)
			(sleep_until (= 0 (recording_time wship)) 5)
			
				(object_destroy wship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport wship 2_loading)
			(recording_play wship 2_loading2)
			
			
			
			(sleep_until (> 880 (recording_time wship)) 5)
			(unit_open wg)
			(sleep 30)
			(ai_braindead 2_loadingbay 0)
			(vehicle_unload wg "")
			
			(objects_detach wship wraitha)
			(objects_detach wship wraithb)
			
			(objects_detach wship ghosta)
			(objects_detach wship ghostb)
			(objects_detach wship ghostc)
			(objects_detach wship ghostd)
			
			(ai_attack 2_loadingbay)
			(sleep_until (= 0 (recording_time wship)) 5)
			
				(object_destroy wship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 2_loadingbay/s 2_loadingbay/c)
					
)

(script continuous sp_2chronoparking

	(sleep -1)
		
				(vehicle_unload xg)
				(sleep 10)
				(object_destroy xcr)
				(object_destroy xcl)
				(object_destroy xg)
				(object_destroy xtl)
				(object_destroy xtr)
				(object_destroy xship)
				
				(object_create xship)
				(object_create xcr)
				(object_create xcl)
				(object_create xtr)
				(object_create xtl)
				(object_create xg)
				(unit_close xtr)
				(unit_close xtl)
				(unit_close xg)
				
				(objects_attach xship "gravlift" xg "")
				(objects_attach xship "troop_door_right" xtr "")
				(objects_attach xship "troop_door_left" xtl "")
				(objects_attach xship "turret_door_left" xcr "")
				(objects_attach xship "turret_door_right" xcl "")
				
	(set softlock 1)
	
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
	
	
	

	
	(cond 
					((= 0 vehicle_id)
						(sleep 1)
					)
					((= 1 vehicle_id)
						(begin
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach xship "small_cargo01" GHOST "" )
							(ai_migrate driver/ghost 2_chronoghosts)
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach xship "small_cargo02" GHOST "")
							(ai_migrate driver/ghost 2_chronoghosts)
							(set vehicle_id 0)
						)
					)
					((= 2 vehicle_id)	
						(begin
							(set softlock 1)
							(spawn_wraith)
							(sleep_until (= 0 softlock) 5)
							(objects_attach xship "large_cargo" WRAITH "" )
							(ai_migrate driver/ghost 2_chronoghosts)
							(set vehicle_id 0)
						)
					)
	)
	
	
	
	
	
	(vehicle_load_magic xg "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 2_chronoparking/s)
	(set spawning 0)
	
	(set tempint (random_range 1 3))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport xship 2_chronoa)
			(recording_play xship 2_chronoa1)
			
			
			
			(sleep_until (> 1060 (recording_time xship)) 5)
			(unit_open xg)
			(sleep 30)
			(ai_braindead 2_chronoparking 0)
			(vehicle_unload xg "")
			
			(objects_detach xship wraitha)
			(objects_detach xship wraithb)
			
			(objects_detach xship ghosta)
			(objects_detach xship ghostb)
			(objects_detach xship ghostc)
			(objects_detach xship ghostd)
			
			
			(ai_attack 2_chronoparking)
			(sleep_until (= 0 (recording_time xship)) 5)
			
				(object_destroy xship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport xship 2_chronoa)
			(recording_play xship 2_chronoa2)
			
			
			
			(sleep_until (> 1005 (recording_time xship)) 5)
			(unit_open xg)
			(sleep 30)
			(ai_braindead 2_chronoparking 0)
			(vehicle_unload xg "")
			
			(objects_detach xship wraitha)
			(objects_detach xship wraithb)
			
			(objects_detach xship ghosta)
			(objects_detach xship ghostb)
			(objects_detach xship ghostc)
			(objects_detach xship ghostd)
			
			(ai_attack 2_chronoparking)
			(sleep_until (= 0 (recording_time xship)) 5)
			
				(object_destroy xship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 2_chronoparking/s 2_chronoparking/c)
					
)

(script continuous sp_2chronorear

	(sleep -1)
		
				(vehicle_unload yg)
				(sleep 10)
				(object_destroy ycr)
				(object_destroy ycl)
				(object_destroy yg)
				(object_destroy ytl)
				(object_destroy ytr)
				(object_destroy yship)
				
				(object_create yship)
				(object_create ycr)
				(object_create ycl)
				(object_create ytr)
				(object_create ytl)
				(object_create yg)
				(unit_close ytr)
				(unit_close ytl)
				(unit_close yg)
				
				(objects_attach yship "gravlift" yg "")
				(objects_attach yship "troop_door_right" ytr "")
				(objects_attach yship "troop_door_left" ytl "")
				(objects_attach yship "turret_door_left" ycr "")
				(objects_attach yship "turret_door_right" ycl "")
				
	(set softlock 1)
	
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
	
	
	

	
	(cond 
					((= 0 vehicle_id)
						(sleep 1)
					)
					((= 1 vehicle_id)
						(begin
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach yship "small_cargo01" GHOST "" )
							(ai_migrate driver/ghost 2_chronoghosts)
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach yship "small_cargo02" GHOST "")
							(ai_migrate driver/ghost 2_chronoghosts)
							(set vehicle_id 0)
						)
					)
					((= 2 vehicle_id)	
						(begin
							(set softlock 1)
							(spawn_wraith)
							(sleep_until (= 0 softlock) 5)
							(objects_attach yship "large_cargo" WRAITH "" )
							(ai_migrate driver/ghost 2_chronoghosts)
							(set vehicle_id 0)
						)
					)
	)
	
	
	
	
	
	(vehicle_load_magic yg "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 2_chronorear/s)
	(set spawning 0)
	
	(set tempint (random_range 1 3))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport yship 2_chronob)
			(recording_play yship 2_chronob1)
			
			
			
			(sleep_until (> 1305 (recording_time yship)) 5)
			(unit_open yg)
			(sleep 30)
			(ai_braindead 2_chronorear 0)
			(vehicle_unload yg "")
			
			(objects_detach yship wraitha)
			(objects_detach yship wraithb)
			
			(objects_detach yship ghosta)
			(objects_detach yship ghostb)
			(objects_detach yship ghostc)
			(objects_detach yship ghostd)
			
			
			(ai_attack 2_chronorear)
			(sleep_until (= 0 (recording_time yship)) 5)
			
				(object_destroy yship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport yship 2_chronob)
			(recording_play yship 2_chronob2)
			
			
			
			(sleep_until (> 980 (recording_time yship)) 5)
			(unit_open yg)
			(sleep 30)
			(ai_braindead 2_chronorear 0)
			(vehicle_unload yg "")
			
			(objects_detach yship wraitha)
			(objects_detach yship wraithb)
			
			(objects_detach yship ghosta)
			(objects_detach yship ghostb)
			(objects_detach yship ghostc)
			(objects_detach yship ghostd)
			
			(ai_attack 2_chronorear)
			(sleep_until (= 0 (recording_time yship)) 5)
			
				(object_destroy yship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 2_chronorear/s 2_chronorear/c)
					
)
;;;;;

;;;;

;; BSP 3

;;;;;;

;;;;;

(script continuous sp_3front

	(sleep -1)
		
				(vehicle_unload xg)
				(sleep 10)
				(object_destroy xcr)
				(object_destroy xcl)
				(object_destroy xg)
				(object_destroy xtl)
				(object_destroy xtr)
				(object_destroy xship)
				
				(object_create xship)
				(object_create xcr)
				(object_create xcl)
				(object_create xtr)
				(object_create xtl)
				(object_create xg)
				(unit_close xtr)
				(unit_close xtl)
				(unit_close xg)
				
				(objects_attach xship "gravlift" xg "")
				(objects_attach xship "troop_door_right" xtr "")
				(objects_attach xship "troop_door_left" xtl "")
				(objects_attach xship "turret_door_left" xcr "")
				(objects_attach xship "turret_door_right" xcl "")
				
	(set softlock 1)
	
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
	
	
	

	
	(cond 
					((= 0 vehicle_id)
						(sleep 1)
					)
					((= 1 vehicle_id)
						(begin
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach xship "small_cargo01" GHOST "" )
							(ai_migrate driver/ghost 3_ghost)
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach xship "small_cargo02" GHOST "")
							(ai_migrate driver/ghost 3_ghost)
							(set vehicle_id 0)
						)
					)
					((= 2 vehicle_id)	
						(begin
							(set softlock 1)
							(spawn_wraith)
							(sleep_until (= 0 softlock) 5)
							(objects_attach xship "large_cargo" WRAITH "" )
							(ai_migrate driver/ghost 3_ghost)
							(set vehicle_id 0)
						)
					)
	)
	
	
	
	
	
	(vehicle_load_magic xg "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 3_front/s)
	(set spawning 0)
	
	(set tempint (random_range 1 6))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport xship 3_frontA)
			(recording_play xship 3_frontA1)
			
			
			
			(sleep_until (> 930 (recording_time xship)) 5)
			(unit_open xg)
			(sleep 30)
			(ai_braindead 3_front 0)
			(vehicle_unload xg "")
			
			(objects_detach xship wraitha)
			(objects_detach xship wraithb)
			
			(objects_detach xship ghosta)
			(objects_detach xship ghostb)
			(objects_detach xship ghostc)
			(objects_detach xship ghostd)
			
			
			(ai_attack 3_front)
			(sleep_until (= 0 (recording_time xship)) 5)
			
				(object_destroy xship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport xship 3_fronta)
			(recording_play xship 3_fronta2)
			
			
			
			(sleep_until (> 760 (recording_time xship)) 5)
			(unit_open xg)
			(sleep 30)
			(ai_braindead 3_front 0)
			(vehicle_unload xg "")
			
			(objects_detach xship wraitha)
			(objects_detach xship wraithb)
			
			(objects_detach xship ghosta)
			(objects_detach xship ghostb)
			(objects_detach xship ghostc)
			(objects_detach xship ghostd)
			
			(ai_attack 3_front)
			(sleep_until (= 0 (recording_time xship)) 5)
			
				(object_destroy xship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 3 tempint) 
		(begin
			(object_teleport xship 3_fronta3)
			(recording_play xship 3_fronta3)
			
			
			
			(sleep_until (> 740 (recording_time xship)) 5)
			(unit_open xg)
			(sleep 30)
			(ai_braindead 3_front 0)
			(vehicle_unload xg "")
			
			(objects_detach xship wraitha)
			(objects_detach xship wraithb)
			
			(objects_detach xship ghosta)
			(objects_detach xship ghostb)
			(objects_detach xship ghostc)
			(objects_detach xship ghostd)
			
			(ai_attack 3_front)
			(sleep_until (= 0 (recording_time xship)) 5)
			
				(object_destroy xship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 4 tempint) 
		(begin
			(object_teleport xship 3_frontb)
			(recording_play xship 3_frontb1)
			
			
			
			(sleep_until (> 910 (recording_time xship)) 5)
			(unit_open xg)
			(sleep 30)
			(ai_braindead 3_front 0)
			(vehicle_unload xg "")
			
			(objects_detach xship wraitha)
			(objects_detach xship wraithb)
			
			(objects_detach xship ghosta)
			(objects_detach xship ghostb)
			(objects_detach xship ghostc)
			(objects_detach xship ghostd)
			
			(ai_attack 3_front)
			(sleep_until (= 0 (recording_time xship)) 5)
			
				(object_destroy xship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 5 tempint) 
		(begin
			(object_teleport xship 3_frontb)
			(recording_play xship 3_frontb2)
			
			
			
			(sleep_until (> 860 (recording_time xship)) 5)
			(unit_open xg)
			(sleep 30)
			(ai_braindead 3_front 0)
			(vehicle_unload xg "")
			
			(objects_detach xship wraitha)
			(objects_detach xship wraithb)
			
			(objects_detach xship ghosta)
			(objects_detach xship ghostb)
			(objects_detach xship ghostc)
			(objects_detach xship ghostd)
			
			(ai_attack 3_front)
			(sleep_until (= 0 (recording_time xship)) 5)
			
				(object_destroy xship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 3_front/s 3_front/c)
					
)









(script continuous sp_3back

	(sleep -1)
		
				(vehicle_unload yg)
				(sleep 10)
				(object_destroy ycr)
				(object_destroy ycl)
				(object_destroy yg)
				(object_destroy ytl)
				(object_destroy ytr)
				(object_destroy yship)
				
				(object_create yship)
				(object_create ycr)
				(object_create ycl)
				(object_create ytr)
				(object_create ytl)
				(object_create yg)
				(unit_close ytr)
				(unit_close ytl)
				(unit_close yg)
				
				(objects_attach yship "gravlift" yg "")
				(objects_attach yship "troop_door_right" ytr "")
				(objects_attach yship "troop_door_left" ytl "")
				(objects_attach yship "turret_door_left" yCR "")
				(objects_attach yship "turret_door_right" yCL "")
				
	(set softlock 1)
	
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
	
	
	

	
	(cond 
					((= 0 vehicle_id)
						(sleep 1)
					)
					((= 1 vehicle_id)
						(begin
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach yship "small_cargo01" GHOST "" )
							(ai_migrate driver/ghost 3_ghost)
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach yship "small_cargo02" GHOST "")
							(ai_migrate driver/ghost 3_ghost)
							(set vehicle_id 0)
						)
					)
					((= 2 vehicle_id)	
						(begin
							(set softlock 1)
							(spawn_wraith)
							(sleep_until (= 0 softlock) 5)
							(objects_attach yship "large_cargo" WRAITH "" )
							(ai_migrate driver/ghost 3_ghost)
							(set vehicle_id 0)
						)
					)
	)
	
	
	
	
	
	(vehicle_load_magic yg "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 3_back/s)
	(set spawning 0)
	
	(set tempint (random_range 1 4))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport yship 3_backA)
			(recording_play yship 3_backA1)
			
			
			
			(sleep_until (> 790 (recording_time yship)) 5)
			(unit_open yg)
			(sleep 30)
			(ai_braindead 3_back 0)
			(vehicle_unload yg "")
			
			(objects_detach yship wraitha)
			(objects_detach yship wraithb)
			
			(objects_detach yship ghosta)
			(objects_detach yship ghostb)
			(objects_detach yship ghostc)
			(objects_detach yship ghostd)
			
			
			(ai_attack 3_back)
			(sleep_until (= 0 (recording_time yship)) 5)
			
				(object_destroy yship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport yship 3_backa2)
			(recording_play yship 3_backa2)
			
			
			
			(sleep_until (> 765 (recording_time yship)) 5)
			(unit_open yg)
			(sleep 30)
			(ai_braindead 3_back 0)
			(vehicle_unload yg "")
			
			(objects_detach yship wraitha)
			(objects_detach yship wraithb)
			
			(objects_detach yship ghosta)
			(objects_detach yship ghostb)
			(objects_detach yship ghostc)
			(objects_detach yship ghostd)
			
			(ai_attack 3_back)
			(sleep_until (= 0 (recording_time yship)) 5)
			
				(object_destroy yship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 3 tempint) 
		(begin
			(object_teleport yship 3_backa2)
			(recording_play yship 3_backa3)
			
			
			
			(sleep_until (> 1025 (recording_time yship)) 5)
			(unit_open yg)
			(sleep 30)
			(ai_braindead 3_back 0)
			(vehicle_unload yg "")
			
			(objects_detach yship wraitha)
			(objects_detach yship wraithb)
			
			(objects_detach yship ghosta)
			(objects_detach yship ghostb)
			(objects_detach yship ghostc)
			(objects_detach yship ghostd)
			
			(ai_attack 3_back)
			(sleep_until (= 0 (recording_time yship)) 5)
			
				(object_destroy yship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 3_back/s 3_back/c)
	
					
)
;;;;;

;;;;

;; BSP 4

;;;;;;

;;;;;



(script continuous sp_4front

	(sleep -1)
		
	
				(vehicle_unload ug)
				(sleep 10)
				(object_destroy UCR)
				(object_destroy UCL)
				(object_destroy ug)
				(object_destroy utl)
				(object_destroy utr)
				(object_destroy uship)
				
				(object_create uship)
				(object_create ucr)
				(object_create ucl)
				(object_create utr)
				(object_create utl)
				(object_create ug)
				
				(objects_attach uship "gravlift" ug "")
				(objects_attach uship "troop_door_right" utr "")
				(objects_attach uship "troop_door_left" utl "")
				(objects_attach uship "turret_door_left" ucr "")
				(objects_attach uship "turret_door_right" ucl "")

	
	
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
		
	(cond 
					((= 0 vehicle_id)
						(sleep 1)
					)
					((= 1 vehicle_id)
						(begin
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach uship "small_cargo01" GHOST "" )
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach uship "small_cargo02" GHOST "")
							(set vehicle_id 0)
							(ai_migrate driver/ghost 4_bridgeghost)
						)
					)
					((= 2 vehicle_id)	
						(begin
							(set softlock 1)
							(spawn_wraith)
							(sleep_until (= 0 softlock) 5)
							(objects_attach uship "large_cargo" WRAITH "" )
							(ai_migrate driver/ghost 4_bridgeghost)
							(set vehicle_id 0)
						)
					)
	)
	
	
	
	
	
	(vehicle_load_magic ug "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 4_front/s)
	(set spawning 0)
	
	
	(set tempint (random_range 1 3))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport uship 4_cityscapeC)
			(recording_play uship 4_cityscapeC1)
			
			
			
			(sleep_until (> 965 (recording_time uship)) 5)
			(unit_open ug)
			(sleep 30)
			(ai_braindead 4_front 0)
			(vehicle_unload ug "")
			
			(objects_detach uship wraitha)
			(objects_detach uship wraithb)
			
			(objects_detach uship ghosta)
			(objects_detach uship ghostb)
			(objects_detach uship ghostc)
			(objects_detach uship ghostd)
			
			(ai_attack 4_front)
			(sleep_until (= 0 (recording_time uship)) 5)
			
				(object_destroy uship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport uship 4_cityscapeC2)
			(recording_play uship 4_cityscapeC2)
			
			
			
			(sleep_until (> 975 (recording_time uship)) 5)
			(unit_open ug)
			(sleep 30)
			(ai_braindead 4_front 0)
			(vehicle_unload ug "")
			
			(objects_detach uship wraitha)
			(objects_detach uship wraithb)
			
			(objects_detach uship ghosta)
			(objects_detach uship ghostb)
			(objects_detach uship ghostc)
			(objects_detach uship ghostd)
			
			(ai_attack 4_front)
			(sleep_until (= 0 (recording_time uship)) 5)
			
				(object_destroy uship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 4_front/s 4_front/c)
					
)



(script continuous sp_4mid

	(sleep -1)
		
	
				(vehicle_unload vg)
				(sleep 10)
				(object_destroy vCR)
				(object_destroy vCL)
				(object_destroy vg)
				(object_destroy vtl)
				(object_destroy vtr)
				(object_destroy vship)
				
				(object_create vship)
				(object_create vcr)
				(object_create vcl)
				(object_create vtr)
				(object_create vtl)
				(object_create vg)
				(unit_close vtr)
				(unit_close vtl)
				(unit_close vg)
				
				(objects_attach vship "gravlift" vg "")
				(objects_attach vship "troop_door_right" vtr "")
				(objects_attach vship "troop_door_left" vtl "")
				(objects_attach vship "turret_door_left" vcr "")
				(objects_attach vship "turret_door_right" vcl "")

	
	
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
		
	(cond 
					((= 0 vehicle_id)
						(sleep 1)
					)
					((= 1 vehicle_id)
						(begin
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach vship "small_cargo01" GHOST "" )
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach vship "small_cargo02" GHOST "")
							(set vehicle_id 0)
							(ai_migrate driver/ghost 4_bridgeghost)
						)
					)
					((= 2 vehicle_id)	
						(begin
							(set softlock 1)
							(spawn_wraith)
							(sleep_until (= 0 softlock) 5)
							(objects_attach vship "large_cargo" WRAITH "" )
							(ai_migrate driver/ghost 4_bridgeghost)
							(set vehicle_id 0)
						)
					)
	)
	
	
	
	
	
	(vehicle_load_magic vg "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 4_mid/s)
	(set spawning 0)
	
	
	(set tempint (random_range 1 3))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport vship 4_bridgeA)
			(recording_play vship 4_bridge1)
			
			
			
			(sleep_until (> 965 (recording_time vship)) 5)
			(unit_open vg)
			(sleep 30)
			(ai_braindead 4_mid 0)
			(vehicle_unload vg "")
			
			(objects_detach vship wraitha)
			(objects_detach vship wraithb)
			
			(objects_detach vship ghosta)
			(objects_detach vship ghostb)
			(objects_detach vship ghostc)
			(objects_detach vship ghostd)
			
			(ai_attack 4_mid)
			(sleep_until (= 0 (recording_time vship)) 5)
			
				(object_destroy vship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport vship 4_bridgeB)
			(recording_play vship 4_bridge2)
			
			
			
			(sleep_until (> 1200 (recording_time vship)) 5)
			(unit_open vg)
			(sleep 30)
			(ai_braindead 4_mid 0)
			(vehicle_unload vg "")
			
			(objects_detach vship wraitha)
			(objects_detach vship wraithb)
			
			(objects_detach vship ghosta)
			(objects_detach vship ghostb)
			(objects_detach vship ghostc)
			(objects_detach vship ghostd)
			
			(ai_attack 4_mid)
			(sleep_until (= 0 (recording_time vship)) 5)
			
				(object_destroy vship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 4_mid/s 4_mid/c)
					
)



(script continuous sp_4back

	(sleep -1)
		
	
				(vehicle_unload wg)
				(sleep 10)
				(object_destroy wCR)
				(object_destroy wCL)
				(object_destroy wg)
				(object_destroy wtl)
				(object_destroy wtr)
				(object_destroy wship)
				
				(object_create wship)
				(object_create wcr)
				(object_create wcl)
				(object_create wtr)
				(object_create wtl)
				(object_create wg)
				(unit_close wtr)
				(unit_close wtl)
				(unit_close wg)
				
				(objects_attach wship "gravlift" wg "")
				(objects_attach wship "troop_door_right" wtr "")
				(objects_attach wship "troop_door_left" wtl "")
				(objects_attach wship "turret_door_left" wcr "")
				(objects_attach wship "turret_door_right" wcl "")

	
	
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
		
	(cond 
					((= 0 vehicle_id)
						(sleep 1)
					)
					((= 1 vehicle_id)
						(begin
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach wship "small_cargo01" GHOST "" )
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach wship "small_cargo02" GHOST "")
							(set vehicle_id 0)
							(ai_migrate driver/ghost 4_bridgeghost)
						)
					)
					((= 2 vehicle_id)	
						(begin
							(set softlock 1)
							(spawn_wraith)
							(sleep_until (= 0 softlock) 5)
							(objects_attach wship "large_cargo" WRAITH "" )
							(ai_migrate driver/ghost 4_bridgeghost)
							(set vehicle_id 0)
						)
					)
	)
	
	
	
	
	
	(vehicle_load_magic wg "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 4_back/s)
	(set spawning 0)
	
	
	(set tempint (random_range 1 3))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport wship 4_cityscapeA)
			(recording_play wship 4_cityscapeA4)
			
			
			
			(sleep_until (> 820 (recording_time wship)) 5)
			(unit_open wg)
			(sleep 30)
			(ai_braindead 4_back 0)
			(vehicle_unload wg "")
			
			(objects_detach wship wraitha)
			(objects_detach wship wraithb)
			
			(objects_detach wship ghosta)
			(objects_detach wship ghostb)
			(objects_detach wship ghostc)
			(objects_detach wship ghostd)
			
			(ai_attack 4_back)
			(sleep_until (= 0 (recording_time wship)) 5)
			
				(object_destroy wship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport wship 4_cityscapeA)
			(recording_play wship 4_cityscapeA5)
			
			
			
			(sleep_until (> 950 (recording_time wship)) 5)
			(unit_open wg)
			(sleep 30)
			(ai_braindead 4_back 0)
			(vehicle_unload wg "")
			
			(objects_detach wship wraitha)
			(objects_detach wship wraithb)
			
			(objects_detach wship ghosta)
			(objects_detach wship ghostb)
			(objects_detach wship ghostc)
			(objects_detach wship ghostd)
			
			(ai_attack 4_back)
			(sleep_until (= 0 (recording_time wship)) 5)
			
				(object_destroy wship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 4_back/s 4_back/c)
					
)



(script continuous sp_4A

	(sleep -1)
		
	
				(vehicle_unload xg)
				(sleep 10)
				(object_destroy xcr)
				(object_destroy xcl)
				(object_destroy xg)
				(object_destroy xtl)
				(object_destroy xtr)
				(object_destroy xship)
				
				(object_create xship)
				(object_create xcr)
				(object_create xcl)
				(object_create xtr)
				(object_create xtl)
				(object_create xg)
				(unit_close xtr)
				(unit_close xtl)
				(unit_close xg)
				
				(objects_attach xship "gravlift" xg "")
				(objects_attach xship "troop_door_right" xtr "")
				(objects_attach xship "troop_door_left" xtl "")
				(objects_attach xship "turret_door_left" xcr "")
				(objects_attach xship "turret_door_right" xcl "")

	
	
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
		
	(cond 
					((= 0 vehicle_id)
						(sleep 1)
					)
					((= 1 vehicle_id)
						(begin
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach xship "small_cargo01" GHOST "" )
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach xship "small_cargo02" GHOST "")
							(set vehicle_id 0)
							(ai_migrate driver/ghost 4_bridgeghost)
						)
					)
					((= 2 vehicle_id)	
						(begin
							(set softlock 1)
							(spawn_wraith)
							(sleep_until (= 0 softlock) 5)
							(objects_attach xship "large_cargo" WRAITH "" )
							(ai_migrate driver/ghost 4_bridgeghost)
							(set vehicle_id 0)
						)
					)
	)
	
	
	
	
	
	(vehicle_load_magic xg "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 4_a/s)
	(set spawning 0)
	
	
	(set tempint (random_range 1 5))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport xship 4_cityscapeA)
			(recording_play xship 4_cityscapeA1)
			
			
			
			(sleep_until (> 1020 (recording_time xship)) 5)
			(unit_open xg)
			(sleep 30)
			(ai_braindead 4_a 0)
			(vehicle_unload xg "")
			
			(objects_detach xship wraitha)
			(objects_detach xship wraithb)
			
			(objects_detach xship ghosta)
			(objects_detach xship ghostb)
			(objects_detach xship ghostc)
			(objects_detach xship ghostd)
			
			(ai_attack 4_a)
			(sleep_until (= 0 (recording_time xship)) 5)
			
				(object_destroy xship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport xship 4_cityscapeA2)
			(recording_play xship 4_cityscapeA2)
			
			
			
			(sleep_until (> 1050 (recording_time xship)) 5)
			(unit_open xg)
			(sleep 30)
			(ai_braindead 4_a 0)
			(vehicle_unload xg "")
			
			(objects_detach xship wraitha)
			(objects_detach xship wraithb)
			
			(objects_detach xship ghosta)
			(objects_detach xship ghostb)
			(objects_detach xship ghostc)
			(objects_detach xship ghostd)
			
			(ai_attack 4_a)
			(sleep_until (= 0 (recording_time xship)) 5)
			
				(object_destroy xship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 3 tempint) 
		(begin
			(object_teleport xship 4_cityscapeA22)
			(recording_play xship 4_cityscapeA2)
			
			
			
			(sleep_until (> 1050 (recording_time xship)) 5)
			(unit_open xg)
			(sleep 30)
			(ai_braindead 4_a 0)
			(vehicle_unload xg "")
			
			(objects_detach xship wraitha)
			(objects_detach xship wraithb)
			
			(objects_detach xship ghosta)
			(objects_detach xship ghostb)
			(objects_detach xship ghostc)
			(objects_detach xship ghostd)
			
			(ai_attack 4_a)
			(sleep_until (= 0 (recording_time xship)) 5)
			
				(object_destroy xship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 4 tempint) 
		(begin
			(object_teleport xship 4_cityscapeA2)
			(recording_play xship 4_cityscapeA3)
			
			
			
			(sleep_until (> 1010 (recording_time xship)) 5)
			(unit_open xg)
			(sleep 30)
			(ai_braindead 4_a 0)
			(vehicle_unload xg "")
			
			(objects_detach xship wraitha)
			(objects_detach xship wraithb)
			
			(objects_detach xship ghosta)
			(objects_detach xship ghostb)
			(objects_detach xship ghostc)
			(objects_detach xship ghostd)
			
			(ai_attack 4_a)
			(sleep_until (= 0 (recording_time xship)) 5)
			
				(object_destroy xship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 4_a/s 4_a/c)
	
)


(script continuous sp_4B

	(sleep -1)
		
	
				(vehicle_unload yg)
				(sleep 10)
				(object_destroy ycr)
				(object_destroy ycl)
				(object_destroy yg)
				(object_destroy ytl)
				(object_destroy ytr)
				(object_destroy yship)
				
				(object_create yship)
				(object_create ycr)
				(object_create ycl)
				(object_create ytr)
				(object_create ytl)
				(object_create yg)
				(unit_close ytr)
				(unit_close ytl)
				(unit_close yg)
				
				(objects_attach yship "gravlift" yg "")
				(objects_attach yship "troop_door_right" ytr "")
				(objects_attach yship "troop_door_left" ytl "")
				(objects_attach yship "turret_door_left" ycr "")
				(objects_attach yship "turret_door_right" ycl "")

	
	
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
		
	(cond 
					((= 0 vehicle_id)
						(sleep 1)
					)
					((= 1 vehicle_id)
						(begin
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach yship "small_cargo01" GHOST "" )
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach yship "small_cargo02" GHOST "")
							(set vehicle_id 0)
							(ai_migrate driver/ghost 4_bridgeghost)
						)
					)
					((= 2 vehicle_id)	
						(begin
							(set softlock 1)
							(spawn_wraith)
							(sleep_until (= 0 softlock) 5)
							(objects_attach yship "large_cargo" WRAITH "" )
							(ai_migrate driver/ghost 4_bridgeghost)
							(set vehicle_id 0)
						)
					)
	)
	
	
	
	
	
	(vehicle_load_magic yg "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 4_B/s)
	(set spawning 0)
	
	
	(set tempint (random_range 1 5))
	
	
	
	(if (= 1 tempint) 
		(begin
			(object_teleport yship 4_cityscapeB1)
			(recording_play yship 4_cityscapeB3)
			
			
			
			(sleep_until (> 870 (recording_time yship)) 5)
			(unit_open yg)
			(sleep 30)
			(ai_braindead 4_b 0)
			(vehicle_unload yg "")
			
			(objects_detach yship wraitha)
			(objects_detach yship wraithb)
			
			(objects_detach yship ghosta)
			(objects_detach yship ghostb)
			(objects_detach yship ghostc)
			(objects_detach yship ghostd)
			
			(ai_attack 4_B)
			(sleep_until (= 0 (recording_time yship)) 5)
			
				(object_destroy yship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport yship 4_cityscapeB1)
			(recording_play yship 4_cityscapeB4)
			
			
			
			(sleep_until (> 1140 (recording_time yship)) 5)
			(unit_open yg)
			(sleep 30)
			(ai_braindead 4_b 0)
			(vehicle_unload yg "")
			
			(objects_detach yship wraitha)
			(objects_detach yship wraithb)
			
			(objects_detach yship ghosta)
			(objects_detach yship ghostb)
			(objects_detach yship ghostc)
			(objects_detach yship ghostd)
			
			(ai_attack 4_B)
			(sleep_until (= 0 (recording_time yship)) 5)
			
				(object_destroy yship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 3 tempint) 
		(begin
			(object_teleport yship 4_cityscapeB)
			(recording_play yship 4_cityscapeB5)
			
			
			
			(sleep_until (> 750 (recording_time yship)) 5)
			(unit_open yg)
			(sleep 30)
			(ai_braindead 4_b 0)
			(vehicle_unload yg "")
			
			(objects_detach yship wraitha)
			(objects_detach yship wraithb)
			
			(objects_detach yship ghosta)
			(objects_detach yship ghostb)
			(objects_detach yship ghostc)
			(objects_detach yship ghostd)
			
			(ai_attack 4_B)
			(sleep_until (= 0 (recording_time yship)) 5)
			
				(object_destroy yship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 4 tempint) 
		(begin
			(object_teleport yship 4_cityscapeB)
			(recording_play yship 4_cityscapeB6)
			
			
			
			(sleep_until (> 1050 (recording_time yship)) 5)
			(unit_open yg)
			(sleep 30)
			(ai_braindead 4_b 0)
			(vehicle_unload yg "")
			
			(objects_detach yship wraitha)
			(objects_detach yship wraithb)
			
			(objects_detach yship ghosta)
			(objects_detach yship ghostb)
			(objects_detach yship ghostc)
			(objects_detach yship ghostd)
			
			(ai_attack 4_B)
			(sleep_until (= 0 (recording_time yship)) 5)
			
				(object_destroy yship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 4_b/s 4_b/c)
					
)


(script continuous sp_4C

	(sleep -1)
		
	
				(vehicle_unload zg)
				(sleep 10)
				(object_destroy zcr)
				(object_destroy zcl)
				(object_destroy zg)
				(object_destroy ztl)
				(object_destroy ztr)
				(object_destroy zship)
				
				(object_create zship)
				(object_create zcr)
				(object_create zcl)
				(object_create ztr)
				(object_create ztl)
				(object_create zg)
				(unit_close ztr)
				(unit_close ztl)
				(unit_close zg)
				
				(objects_attach zship "gravlift" zg "")
				(objects_attach zship "troop_door_right" ztr "")
				(objects_attach zship "troop_door_left" ztl "")
				(objects_attach zship "turret_door_left" zcr "")
				(objects_attach zship "turret_door_right" zcl "")

	
	
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
		
	(cond 
					((= 0 vehicle_id)
						(sleep 1)
					)
					((= 1 vehicle_id)
						(begin
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach zship "small_cargo01" GHOST "" )
							(set softlock 1)
							(spawn_ghost)
							(sleep_until (= 0 softlock) 5)
							(objects_attach zship "small_cargo02" GHOST "")
							(set vehicle_id 0)
							(ai_migrate driver/ghost 4_bridgeghost)
						)
					)
					((= 2 vehicle_id)	
						(begin
							(set softlock 1)
							(spawn_wraith)
							(sleep_until (= 0 softlock) 5)
							(objects_attach zship "large_cargo" WRAITH "" )
							(ai_migrate driver/ghost 4_bridgeghost)
							(set vehicle_id 0)
						)
					)
	)
	
	
	
	
	
	(vehicle_load_magic zg "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 4_c/s)
	(set spawning 0)
	
	
	(set tempint (random_range 1 3))
	
	
	
	(if (= 1 tempint) 
		(begin
			(object_teleport zship 4_cityscapeB1)
			(recording_play zship 4_cityscapeB1)
			
			
			
			(sleep_until (> 910 (recording_time zship)) 5)
			(unit_open zg)
			(sleep 30)
			(ai_braindead 4_c 0)
			(vehicle_unload zg "")
			
			(objects_detach zship wraitha)
			(objects_detach zship wraithb)
			
			(objects_detach zship ghosta)
			(objects_detach zship ghostb)
			(objects_detach zship ghostc)
			(objects_detach zship ghostd)
			
			(ai_attack 4_c)
			(sleep_until (= 0 (recording_time zship)) 5)
			
				(object_destroy zship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport zship 4_cityscapeB1)
			(recording_play zship 4_cityscapeB2)
			
			
			
			(sleep_until (> 930 (recording_time zship)) 5)
			(unit_open zg)
			(sleep 30)
			(ai_braindead 4_c 0)
			(vehicle_unload zg "")
			
			(objects_detach zship wraitha)
			(objects_detach zship wraithb)
			
			(objects_detach zship ghosta)
			(objects_detach zship ghostb)
			(objects_detach zship ghostc)
			(objects_detach zship ghostd)
			
			(ai_attack 4_c)
			(sleep_until (= 0 (recording_time zship)) 5)
			
				(object_destroy zship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 4_c/s 4_c/c)
	
					
)



(script continuous sp_5A

	(sleep -1)
		
	
				(vehicle_unload ug)
				(sleep 10)
				(object_destroy UCR)
				(object_destroy UCL)
				(object_destroy ug)
				(object_destroy utl)
				(object_destroy utr)
				(object_destroy uship)
				
				(object_create uship)
				(object_create ucr)
				(object_create ucl)
				(object_create utr)
				(object_create utl)
				(object_create ug)
				
				(objects_attach uship "gravlift" ug "")
				(objects_attach uship "troop_door_right" utr "")
				(objects_attach uship "troop_door_left" utl "")
				(objects_attach uship "turret_door_left" ucr "")
				(objects_attach uship "turret_door_right" ucl "")

	
	
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
	
	
	
	
	(vehicle_load_magic ug "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 5_A/s)
	(set spawning 0)
	
	
	(set tempint (random_range 1 5))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport uship 5_tombstoneA)
			(recording_play uship 5_tombstoneA1)
			
			
			
			(sleep_until (> 850 (recording_time uship)) 5)
			(unit_open ug)
			(sleep 30)
			(ai_braindead 5_a 0)
			(vehicle_unload ug "")
			
			(objects_detach uship wraitha)
			(objects_detach uship wraithb)
			
			(objects_detach uship ghosta)
			(objects_detach uship ghostb)
			(objects_detach uship ghostc)
			(objects_detach uship ghostd)
			
			(ai_attack 5_A)
			(sleep_until (= 0 (recording_time uship)) 5)
			
				(object_destroy uship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport uship 5_tombstoneA)
			(recording_play uship 5_tombstoneA2)
			
			
			
			(sleep_until (> 930 (recording_time uship)) 5)
			(unit_open ug)
			(sleep 30)
			(ai_braindead 5_a 0)
			(vehicle_unload ug "")
			
			(objects_detach uship wraitha)
			(objects_detach uship wraithb)
			
			(objects_detach uship ghosta)
			(objects_detach uship ghostb)
			(objects_detach uship ghostc)
			(objects_detach uship ghostd)
			
			(ai_attack 5_A)
			(sleep_until (= 0 (recording_time uship)) 5)
			
				(object_destroy uship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 3 tempint) 
		(begin
			(object_teleport uship 5_tombstoneB1)
			(recording_play uship 5_tombstoneB1)
			
			
			
			(sleep_until (> 760 (recording_time uship)) 5)
			(unit_open ug)
			(sleep 30)
			(ai_braindead 5_a 0)
			(vehicle_unload ug "")
			
			(objects_detach uship wraitha)
			(objects_detach uship wraithb)
			
			(objects_detach uship ghosta)
			(objects_detach uship ghostb)
			(objects_detach uship ghostc)
			(objects_detach uship ghostd)
			
			(ai_attack 5_A)
			(sleep_until (= 0 (recording_time uship)) 5)
			
				(object_destroy uship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 4 tempint) 
		(begin
			(object_teleport uship 5_tombstoneB)
			(recording_play uship 5_tombstoneB2)
			
			
			
			(sleep_until (> 1180 (recording_time uship)) 5)
			(unit_open ug)
			(sleep 30)
			(ai_braindead 5_a 0)
			(vehicle_unload ug "")
			
			(objects_detach uship wraitha)
			(objects_detach uship wraithb)
			
			(objects_detach uship ghosta)
			(objects_detach uship ghostb)
			(objects_detach uship ghostc)
			(objects_detach uship ghostd)
			
			(ai_attack 5_A)
			(sleep_until (= 0 (recording_time uship)) 5)
			
				(object_destroy uship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 5_a/s 5_a/c)		
)




(script continuous sp_5B

	(sleep -1)
		
	
				(vehicle_unload vg)
				(sleep 10)
				(object_destroy vCR)
				(object_destroy vCL)
				(object_destroy vg)
				(object_destroy vtl)
				(object_destroy vtr)
				(object_destroy vship)
				
				(object_create vship)
				(object_create vcr)
				(object_create vcl)
				(object_create vtr)
				(object_create vtl)
				(object_create vg)
				(unit_close vtr)
				(unit_close vtl)
				(unit_close vg)
				
				(objects_attach vship "gravlift" vg "")
				(objects_attach vship "troop_door_right" vtr "")
				(objects_attach vship "troop_door_left" vtl "")
				(objects_attach vship "turret_door_left" vcr "")
				(objects_attach vship "turret_door_right" vcl "")

	
	
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
	
	
	
	
	(vehicle_load_magic vg "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 5_B/s)
	(set spawning 0)
	
	
	(set tempint (random_range 1 4))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport vship 5_zanzibarA)
			(recording_play vship 5_zanzibarA1)
			
			
			
			(sleep_until (> 635 (recording_time vship)) 5)
			(unit_open vg)
			(sleep 30)
			(ai_braindead 5_b 0)
			(vehicle_unload vg "")
			
			(objects_detach vship wraitha)
			(objects_detach vship wraithb)
			
			(objects_detach vship ghosta)
			(objects_detach vship ghostb)
			(objects_detach vship ghostc)
			(objects_detach vship ghostd)
			
			(ai_attack 5_b)
			(sleep_until (= 0 (recording_time vship)) 5)
			
				(object_destroy vship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport vship 5_zanzibarA)
			(recording_play vship 5_zanzibarA2)
			
			
			
			(sleep_until (> 810 (recording_time vship)) 5)
			(unit_open vg)
			(sleep 30)
			(ai_braindead 5_b 0)
			(vehicle_unload vg "")
			
			(objects_detach vship wraitha)
			(objects_detach vship wraithb)
			
			(objects_detach vship ghosta)
			(objects_detach vship ghostb)
			(objects_detach vship ghostc)
			(objects_detach vship ghostd)
			
			(ai_attack 5_b)
			(sleep_until (= 0 (recording_time vship)) 5)
			
				(object_destroy vship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 3 tempint) 
		(begin
			(object_teleport vship 5_zanzibarA)
			(recording_play vship 5_zanzibarA3)
			
			
			
			(sleep_until (> 760 (recording_time vship)) 5)
			(unit_open vg)
			(sleep 30)
			(ai_braindead 5_b 0)
			(vehicle_unload vg "")
			
			(objects_detach vship wraitha)
			(objects_detach vship wraithb)
			
			(objects_detach vship ghosta)
			(objects_detach vship ghostb)
			(objects_detach vship ghostc)
			(objects_detach vship ghostd)
			
			(ai_attack 5_b)
			(sleep_until (= 0 (recording_time vship)) 5)
			
				(object_destroy vship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 5_b/s 5_b/c)
					
)



(script continuous sp_5C

	(sleep -1)
		
	
				(vehicle_unload wg)
				(sleep 10)
				(object_destroy wCR)
				(object_destroy wCL)
				(object_destroy wg)
				(object_destroy wtl)
				(object_destroy wtr)
				(object_destroy wship)
				
				(object_create wship)
				(object_create wcr)
				(object_create wcl)
				(object_create wtr)
				(object_create wtl)
				(object_create wg)
				(unit_close wtr)
				(unit_close wtl)
				(unit_close wg)
				
				(objects_attach wship "gravlift" wg "")
				(objects_attach wship "troop_door_right" wtr "")
				(objects_attach wship "troop_door_left" wtl "")
				(objects_attach wship "turret_door_left" wcr "")
				(objects_attach wship "turret_door_right" wcl "")

	
	
	(spawn_ai)
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
	
	
	
	
	(vehicle_load_magic wg "" (ai_actors cspawn))
	(ai_braindead cspawn 1) 
	(ai_migrate cspawn 5_C/s)
	(set spawning 0)
	
	
	(set tempint (random_range 1 4))
	
	(if (= 1 tempint) 
		(begin
			(object_teleport wship 5_zanzibarB)
			(recording_play wship 5_zanzibarB1)
			
			
			
			(sleep_until (> 635 (recording_time wship)) 5)
			(unit_open wg)
			(sleep 30)
			(ai_braindead 5_c 0)
			(vehicle_unload wg "")
			
			(objects_detach wship wraitha)
			(objects_detach wship wraithb)
			
			(objects_detach wship ghosta)
			(objects_detach wship ghostb)
			(objects_detach wship ghostc)
			(objects_detach wship ghostd)
			
			(ai_attack 5_C)
			(sleep_until (= 0 (recording_time wship)) 5)
			
				(object_destroy wship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 2 tempint) 
		(begin
			(object_teleport wship 5_zanzibarB)
			(recording_play wship 5_zanzibarB2)
			
			
			
			(sleep_until (> 810 (recording_time wship)) 5)
			(unit_open wg)
			(sleep 30)
			(ai_braindead 5_c 0)
			(vehicle_unload wg "")
			
			(objects_detach wship wraitha)
			(objects_detach wship wraithb)
			
			(objects_detach wship ghosta)
			(objects_detach wship ghostb)
			(objects_detach wship ghostc)
			(objects_detach wship ghostd)
			
			(ai_attack 5_C)
			(sleep_until (= 0 (recording_time wship)) 5)
			
				(object_destroy wship)
				
				
			(sleep 15)
		)
	)
	
	(if (= 3 tempint) 
		(begin
			(object_teleport wship 5_zanzibarB)
			(recording_play wship 5_zanzibarB3)
			
			
			
			(sleep_until (> 760 (recording_time wship)) 5)
			(unit_open wg)
			(sleep 30)
			(ai_braindead 5_c 0)
			(vehicle_unload wg "")
			
			(objects_detach wship wraitha)
			(objects_detach wship wraithb)
			
			(objects_detach wship ghosta)
			(objects_detach wship ghostb)
			(objects_detach wship ghostc)
			(objects_detach wship ghostd)
			
			(ai_attack 5_C)
			(sleep_until (= 0 (recording_time wship)) 5)
			
				(object_destroy wship)
				
				
			(sleep 15)
		)
	)
	
	(ai_migrate 5_c/s 5_c/c)
	
	
					
)

;;
;;
;; These scripts use spawn point teleportation to move AI into the BSP
;; Instead of dropships. These are for tight spaces and interiors.
;; They utilize trigger volumes to indicate even more precise player position
;; and then spawn AI where the player is sure not to see them.
;;
;;
	

(script continuous sp_1interiors

	(sleep -1)


	(set softlock 1)
	(set spawn_mode 1)
	(spawn_ai)	
	(sleep_until (= 0 softlock) 5)
	(set spawn_mode 0)
	(ai_migrate cspawn 1_interior/spawn)
	(set spawning 0)
	(ai_teleport_to_starting_location 1_interior/spawn)
	(ai_migrate 1_interior/spawn 1_interior/headlong)
	
	
)

(script continuous sp_1parking
	(sleep -1)

	(set softlock 1)
	
	(spawn_ai)	
	(sleep_until (= 0 softlock) 5)
	
	(ai_migrate cspawn 1_parking/spawn)
	(set spawning 0)
	(ai_teleport_to_starting_location 1_parking/spawn)
	(ai_migrate 1_parking/spawn 1_parking/terminal)
	(sleep 10)
	
)


(script continuous sp_1ivory
	(sleep -1)

	(set softlock 1)
	
	(spawn_ai)	
	(sleep_until (= 0 softlock) 5)
	
	
	(cond
		(
		(not (volume_test_objects 1ivorytop (players)))
			(ai_migrate cspawn 1_ivory/spawntop)					
			(ai_teleport_to_starting_location 1_ivory/spawntop)
			(ai_migrate 1_ivory/spawntop 1_ivory/tower)				
		)
		
		(
		(not (volume_test_objects 1ivoryside (players)))
			(ai_migrate cspawn 1_ivory/spawnside)					
			(ai_teleport_to_starting_location 1_ivory/spawnside)
			(ai_migrate 1_ivory/spawnside 1_ivory/tower)			
		)
		
		(
		(not (volume_test_objects 1ivoryback (players)))
			(ai_migrate cspawn 1_ivory/spawnback)	
			(ai_teleport_to_starting_location 1_ivory/spawnback)
			(ai_migrate 1_ivory/spawnback 1_ivory/tower)			
		)	
		(
		(not (volume_test_objects 1ivoryfront (players)))
			(ai_migrate cspawn 1_ivory/spawnfront)					
			(ai_teleport_to_starting_location 1_ivory/spawnfront)
			(ai_migrate 1_ivory/spawnfront 1_ivory/tower)			
		)
	)
	
	(set spawning 0)

	
	
	
)

(script continuous sp_3mid

	(sleep -1)


	(set softlock 1)
	
	(spawn_ai)	
	(sleep_until (= 0 softlock) 5)
	
	(ai_migrate cspawn 3_mid/s)
	(set spawning 0)
	(ai_teleport_to_starting_location 3_mid/s)
	(ai_migrate 3_mid/s 3_mid/c)
	
					
)




;;;;; END OF static void spAWN SCRIPTS
;;;;; END OF static void spAWN SCRIPTS





	
(script continuous spawnWIZARD

	

	(if (= 0 (structure_bsp_index))
		(begin

			(if (and (< (ai_living_count 0_turf) 4) (> 2 shipcount) (or (volume_test_objects 0turf (players)) (volume_test_objects 0town (players)) (volume_test_objects 0alley (players))) (> 18 (+ (ai_living_count 0_jalley) (ai_living_count 0_courtyard) (ai_living_count 0_turf))))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health uship)) 5)
					(wake sp_0turf)
					
					(sleep_until (= 0 spawning) 5)
					(sleep 30)
				)
		
			)
			
			(if (and (< (ai_living_count 0_courtyard) 4) (> 2 shipcount) (or (volume_test_objects 0base (players)) (volume_test_objects 0court (players)) (volume_test_objects 0overpass (players)) (volume_test_objects 0exit (players)) ) (> 18 (+ (ai_living_count 0_jalley) (ai_living_count 0_courtyard) (ai_living_count 0_turf))))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health vship)) 5)
					(wake sp_0courtyard)
					
					(sleep_until (= 0 spawning) 5)
					(sleep 30)
				)
		
			)
			
			(if (and (< (ai_living_count 0_jalley) 4) (> 2 shipcount) (or (volume_test_objects 0overpass (players)) (volume_test_objects 0court (players)) (volume_test_objects 0town (players))) (> 18 (+ (ai_living_count 0_jalley) (ai_living_count 0_courtyard) (ai_living_count 0_turf))))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health wship)) 5)
					(wake sp_0jalley)
					
					(sleep_until (= 0 spawning) 5)
					(sleep 30)
				)
		
			)
			
			
			
		)
	)
	
	
	
	(if (= 1 (structure_bsp_index))
		(begin
		
			(if (and (< (ai_living_count 1_ivory) 4) (volume_test_objects 1ivory (players)) (volume_test_objects 1park (players)) (> 20 (+ (ai_living_count 1_headlong) (ai_living_count 1_terminal) (ai_living_count 1_ivory) (ai_living_count 1_parking) (ai_living_count 1_interior))))
		
				(begin 
					(set spawning 1)
					(wake sp_1ivory)
					(sleep_until (= 0 spawning) 5)
				)
		
			)

			(if (and (< (ai_living_count 1_interior) 4) (not (volume_test_objects 1interiors (players))) (volume_test_objects 1headlong (players)) (> 20 (+ (ai_living_count 1_headlong) (ai_living_count 1_terminal) (ai_living_count 1_ivory) (ai_living_count 1_parking) (ai_living_count 1_interior))))
		
				(begin 
					(set spawning 1)
					(wake sp_1interiors)
					(sleep_until (= 0 spawning) 5)
				)
		
			)
			
			(if (and (< (ai_living_count 1_parking) 4) (not (volume_test_objects 1parkinglot (players))) (or (volume_test_objects 1station (players)) (volume_test_objects 1terminal (players))) (> 20 (+ (ai_living_count 1_headlong) (ai_living_count 1_terminal) (ai_living_count 1_ivory) (ai_living_count 1_parking) (ai_living_count 1_interior))))
		
				(begin 
					(set spawning 1)
					(wake sp_1parking)
					(sleep_until (= 0 spawning) 5)
				)
		
			)
				
			(if (and (< (ai_living_count 1_headlong) 4) (or (volume_test_objects 1headlong (players))(volume_test_objects 1park (players))0) (> 20 (+ (ai_living_count 1_headlong) (ai_living_count 1_terminal) (ai_living_count 1_ivory) (ai_living_count 1_parking) (ai_living_count 1_interior))))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health uship)) 5)
					(wake sp_1headlong)
					(sleep_until (= 0 spawning) 5)
					(sleep 30)
				)
		
			)			
						
			
			(if (and (< (ai_living_count 1_terminal) 4) (or (volume_test_objects 1terminal (players)) (volume_test_objects 1park (players)) (volume_test_objects 1station (players)) (volume_test_objects 1parkinglot (players))) (> 20 (+ (ai_living_count 1_headlong) (ai_living_count 1_terminal) (ai_living_count 1_ivory) (ai_living_count 1_parking) (ai_living_count 1_interior))))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health vship)) 5)
					(wake sp_1terminal)
					(sleep_until (= 0 spawning) 5)
					(sleep 30)
				)
		
			)
			
					
			
			
		)
	)
	
	
	
	(if (= 2 (structure_bsp_index))
		(begin
			
			(if (and (< (ai_living_count 2_newmombasa) 4) (or (volume_test_objects 2mombafront (players)) (volume_test_objects 2metromomba (players)) (volume_test_objects 2mombaback (players))) (> 15 (+ (ai_living_count 2_mombasaghosts) (ai_living_count 2_chronoghosts) (ai_living_count 2_newmombasa) (ai_living_count 2_chronoparking) (ai_living_count 2_mombasarear) (ai_living_count 2_chronorear) (ai_living_count 2_loadingbay) )))
		
				(begin 
					(set spawning 1)
					(if (> 0 (unit_get_health vship))
						(begin
							(wake sp_2newmombasa)
							(sleep_until (= 0 spawning) 5)
						)
					)
					(sleep 30)
					
				)
		
			)
			
			(if (and (< (ai_living_count 2_mombasarear) 4) (or (volume_test_objects 2mombafront (players))  (volume_test_objects 2mombaback (players))) (> 15 (+ (ai_living_count 2_mombasaghosts) (ai_living_count 2_chronoghosts) (ai_living_count 2_newmombasa) (ai_living_count 2_chronoparking) (ai_living_count 2_mombasarear) (ai_living_count 2_chronorear) (ai_living_count 2_loadingbay) )))
		
				(begin 
					(set spawning 1)
					(if (> 0 (unit_get_health uship))
						(begin
							(wake sp_2mombasarear)
							(sleep_until (= 0 spawning) 5)
						)
					)
					(sleep 30)
				)
		
			)
			
			(if (and (< (ai_living_count 2_loadingbay) 4) (or (volume_test_objects 2mombafront (players))  (volume_test_objects 2mombaback (players))) (> 15 (+ (ai_living_count 2_mombasaghosts) (ai_living_count 2_chronoghosts) (ai_living_count 2_newmombasa) (ai_living_count 2_chronoparking) (ai_living_count 2_mombasarear) (ai_living_count 2_chronorear) (ai_living_count 2_loadingbay) )))
		
				(begin 
					(set spawning 1)
					(if (> 0 (unit_get_health wship))
						(begin
							(wake sp_2loadingbay)
							(sleep_until (= 0 spawning) 5)
						)
					)
					
					(sleep 30)
				)
		
			)
			
			(if (and (< (ai_living_count 2_chronoparking) 4) (or (volume_test_objects 2chronopolis (players))  (volume_test_objects 2metrochrono (players))) (> 15 (+ (ai_living_count 2_mombasaghosts) (ai_living_count 2_chronoghosts) (ai_living_count 2_newmombasa) (ai_living_count 2_chronoparking) (ai_living_count 2_mombasarear) (ai_living_count 2_chronorear) (ai_living_count 2_loadingbay) )))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health xship)) 5)
					(wake sp_2chronoparking)
					(sleep_until (= 0 spawning) 5)
					
					(sleep 30)
				)
		
			)
			
				(if (and (< (ai_living_count 2_chronorear) 4) (volume_test_objects 2chronopolis (players)) (> 15 (+ (ai_living_count 2_mombasaghosts) (ai_living_count 2_chronoghosts) (ai_living_count 2_newmombasa) (ai_living_count 2_chronoparking) (ai_living_count 2_mombasarear) (ai_living_count 2_chronorear) (ai_living_count 2_loadingbay) )))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health yship)) 5)
					(wake sp_2chronorear)
					(sleep_until (= 0 spawning) 5)
					
					(sleep 30)
				)
		
			)
			
		)
	)
	
	
	
	(if (= 3 (structure_bsp_index))
		(begin

			(if (and (< (ai_living_count 3_front) 4) (or (volume_test_objects 3front (players)) (volume_test_objects 3mid (players))) (> 18 (+ (ai_living_count 3_front) (ai_living_count 3_back) (ai_living_count 3_mid) (ai_living_count 3_ghost) )))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health xship)) 5)
					(wake sp_3front)
					(sleep_until (= 0 spawning) 5)
					
					(sleep 30)
					
				)
		
			)
			
			(if (and (< (ai_living_count 3_back) 4) (or (volume_test_objects 3mid (players)) (volume_test_objects 3back (players))) (> 18 (+ (ai_living_count 3_front) (ai_living_count 3_back) (ai_living_count 3_mid) (ai_living_count 3_ghost) )))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health yship)) 5)
					(wake sp_3back)
					(sleep_until (= 0 spawning) 5)
					
					(sleep 30)
					
				)
		
			)
			
			(if (and (< (ai_living_count 3_mid) 4) (not (volume_test_objects 3mid (players))) (> 18 (+ (ai_living_count 3_front) (ai_living_count 3_back) (ai_living_count 3_mid) (ai_living_count 3_ghost) )) (> 20 (+ (ai_living_count 3_front) (ai_living_count 3_back) (ai_living_count 3_mid) (ai_living_count 3_ghost) )))
		
				(begin 
					(set spawning 1)
					
					(wake sp_3mid)
					(sleep_until (= 0 spawning) 5)
					(sleep 30)
					
				)
		
			)
			
			
			
		)
	)
	
	
	
	
	(if (= 4 (structure_bsp_index))
		(begin

			(if (and (< (ai_living_count 4_front) 5) (or (volume_test_objects 4front (players)) (volume_test_objects 4mid (players))) (> 20 (+ (ai_living_count 4_front) (ai_living_count 4_mid) (ai_living_count 4_back) (ai_living_count 4_a) (ai_living_count 4_b) (ai_living_count 4_c) )))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health uship)) 5)
					(wake sp_4front)
					(sleep_until (= 0 spawning) 5)
					
					(sleep 30)
					
				)
		
			)
			
			(if (and (< (ai_living_count 4_mid) 5) (or (volume_test_objects 4front (players)) (volume_test_objects 4mid (players)) (volume_test_objects 4back (players))) (> 20 (+ (ai_living_count 4_front) (ai_living_count 4_mid) (ai_living_count 4_back) (ai_living_count 4_a) (ai_living_count 4_b) (ai_living_count 4_c) )))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health vship)) 5)
					(wake sp_4mid)
					(sleep_until (= 0 spawning) 5)
					
					(sleep 30)
					
				)
		
			)
			
			(if (and (< (ai_living_count 4_back) 5) (or (volume_test_objects 4back (players)) (volume_test_objects 4mid (players)) (volume_test_objects 4A (players))) (> 20 (+ (ai_living_count 4_front) (ai_living_count 4_mid) (ai_living_count 4_back) (ai_living_count 4_a) (ai_living_count 4_b) (ai_living_count 4_c) )))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health wship)) 5)
					(wake sp_4back)
					(sleep_until (= 0 spawning) 5)
					
					(sleep 30)
					
				)
		
			)
			
			(if (and (< (ai_living_count 4_A) 5) (or (volume_test_objects 4back (players)) (volume_test_objects 4A (players)) (volume_test_objects 4B (players))) (> 20 (+ (ai_living_count 4_front) (ai_living_count 4_mid) (ai_living_count 4_back) (ai_living_count 4_a) (ai_living_count 4_b) (ai_living_count 4_c) )))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health xship)) 5)
					(wake sp_4A)
					(sleep_until (= 0 spawning) 5)
					
					(sleep 30)
					
				)
		
			)
			
			(if (and (< (ai_living_count 4_B) 5) (or (volume_test_objects 4A (players)) (volume_test_objects 4B (players)) (volume_test_objects 4C (players))) (> 20 (+ (ai_living_count 4_front) (ai_living_count 4_mid) (ai_living_count 4_back) (ai_living_count 4_a) (ai_living_count 4_b) (ai_living_count 4_c) )))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health yship)) 5)
					(wake sp_4B)
					(sleep_until (= 0 spawning) 5)
					
					(sleep 30)
					
				)
		
			)
			
			(if (and (< (ai_living_count 4_C) 5) (or (volume_test_objects 4B (players)) (volume_test_objects 4C (players))) (> 20 (+ (ai_living_count 4_front) (ai_living_count 4_mid) (ai_living_count 4_back) (ai_living_count 4_a) (ai_living_count 4_b) (ai_living_count 4_c) )))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health zship)) 5)
					(wake sp_4C)
					(sleep_until (= 0 spawning) 5)
					
					(sleep 30)
					
				)
		
			)
		
			)
			
		)
	
	
	
	
	(if (= 5 (structure_bsp_index))
		(begin

			(if (and (< (ai_living_count 5_A) 4) (or (volume_test_objects 5A (players)) (volume_test_objects 5B (players))) (> 20 (+ (ai_living_count 5_A) (ai_living_count 5_B) (ai_living_count 5_C) )))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health uship)) 5)
					(wake sp_5A)
					(sleep_until (= 0 spawning) 5)
					
					(sleep 30)
					
				)
		
			)
			
			(if (and (< (ai_living_count 5_B) 4) (or (volume_test_objects 5A (players)) (volume_test_objects 5B (players)) (volume_test_objects 5C (players))) (> 20 (+ (ai_living_count 5_A) (ai_living_count 5_B) (ai_living_count 5_C) )))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health vship)) 5)
					(wake sp_5B)
					(sleep_until (= 0 spawning) 5)
					(sleep 30)
					
				)
		
			)
			
			(if (and (< (ai_living_count 5_C) 4) (or (volume_test_objects 5B (players)) (volume_test_objects 5C (players))) (> 20 (+ (ai_living_count 5_A) (ai_living_count 5_B) (ai_living_count 5_C) )))
		
				(begin 
					(set spawning 1)
					(sleep_until (> 0 (unit_get_health wship)) 5)
					(wake sp_5C)
					(sleep_until (= 0 spawning) 5)
					
					(sleep 30)
					
				)
		
			)
			
		)
	)
)

	
;;;;END OF SPAWNWIZARD CONTINUOUS SCRIPT
;;;;END OF SPAWNWIZARD CONTINUOUS SCRIPT


;;;;END OF SPAWNWIZARD CONTINUOUS SCRIPT
;;;;END OF SPAWNWIZARD CONTINUOUS SCRIPT


			
	

(script continuous 0_base

		(if (= 0 (structure_bsp_index))
			(begin
			
				
				
				
				(if (and (< (ai_living_count 0_underpass) 8) (not (volume_test_objects 0court (players))))
					(begin
					
						(cond
							( 
							(= (game_difficulty_get_real) easy)
								(begin
									(if (> 8 (+ (ai_living_count 0_cybase) (ai_living_count 0_oldtown) (ai_living_count 0_underpass)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 0_migration/underpass)
										(ai_teleport_to_starting_location 0_migration/underpass)
										(ai_migrate 0_migration/underpass 0_underpass/s)
										(ai_attack 0_underpass/s)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) normal)
								(begin
									(if (> 7 (+ (ai_living_count 0_cybase) (ai_living_count 0_oldtown) (ai_living_count 0_underpass)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 0_migration/underpass)
										(ai_teleport_to_starting_location 0_migration/underpass)
										(ai_migrate 0_migration/underpass 0_underpass/s)
										(ai_attack 0_underpass/s)										
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) hard)
								(begin
									(if (> 5 (+ (ai_living_count 0_cybase) (ai_living_count 0_oldtown) (ai_living_count 0_underpass)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 0_migration/underpass)
										(ai_teleport_to_starting_location 0_migration/underpass)
										(ai_migrate 0_migration/underpass 0_underpass/s)
										(ai_attack 0_underpass/s)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) impossible)
								(begin
									(if (> 3 (+ (ai_living_count 0_cybase) (ai_living_count 0_oldtown) (ai_living_count 0_underpass)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 0_migration/underpass)
										(ai_teleport_to_starting_location 0_migration/underpass)
										(ai_migrate 0_migration/underpass 0_underpass/s)
										(ai_attack 0_underpass/s)									
										)							
									)
								)
							)


						
						
						
						)
					
					)	
				)
				
				
				
								(if (and (< (ai_living_count 0_oldtown) 5) (not (volume_test_objects 0overpass (players))))
					(begin
					
						(cond
							( 
							(= (game_difficulty_get_real) easy)
								(begin
									(if (> 8 (+ (ai_living_count 0_cybase) (ai_living_count 0_oldtown) (ai_living_count 0_underpass)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 0_migration/cybase)
										(ai_teleport_to_starting_location 0_migration/cybase)
										(ai_migrate 0_migration/cybase 0_oldtown/s)
										(ai_attack 0_oldtown/s)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) normal)
								(begin
									(if (> 7 (+ (ai_living_count 0_cybase) (ai_living_count 0_oldtown) (ai_living_count 0_underpass)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 0_migration/cybase)
										(ai_teleport_to_starting_location 0_migration/cybase)
										(ai_migrate 0_migration/cybase 0_oldtown/s)
										(ai_attack 0_oldtown/s)										
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) hard)
								(begin
									(if (> 5 (+ (ai_living_count 0_cybase) (ai_living_count 0_oldtown) (ai_living_count 0_underpass)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 0_migration/cybase)
										(ai_teleport_to_starting_location 0_migration/cybase)
										(ai_migrate 0_migration/cybase 0_oldtown/s)
										(ai_attack 0_oldtown/s)										
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) impossible)
								(begin
									(if (> 3 (+ (ai_living_count 0_cybase) (ai_living_count 0_oldtown) (ai_living_count 0_underpass)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 0_migration/cybase)
										(ai_teleport_to_starting_location 0_migration/cybase)
										(ai_migrate 0_migration/cybase 0_oldtown/s)
										(ai_attack 0_oldtown/s)										
										)							
									)
								)
							)


						
						
						
						)
					
					)	
				)
						
		
		

		

				

			)
		)		
		
		
)




(script continuous 1_base

		(if (= 1 (structure_bsp_index))
			(begin
			
				(if (and (< (ai_living_count 1_base) 8) (not (volume_test_objects 0court (players))))
					(begin
					
						(cond
							( 
							(= (game_difficulty_get_real) easy)
								(begin
									(if (> 8 (+ (ai_living_count 1_station) (ai_living_count 1_tower) (ai_living_count 1_base)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 1_migration/station)
										(ai_teleport_to_starting_location 1_migration/station)
										(ai_migrate 1_migration/station 1_station/s)
										(ai_attack 1_station/s)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) normal)
								(begin
									(if (> 7 (+ (ai_living_count 1_station) (ai_living_count 1_tower) (ai_living_count 1_base)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 1_migration/station)
										(ai_teleport_to_starting_location 1_migration/station)
										(ai_migrate 1_migration/station 1_station/s)
										(ai_attack 1_station/s)										
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) hard)
								(begin
									(if (> 5 (+ (ai_living_count 1_station) (ai_living_count 1_tower) (ai_living_count 1_base)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 1_migration/station)
										(ai_teleport_to_starting_location 1_migration/station)
										(ai_migrate 1_migration/station 1_station/s)
										(ai_attack 1_station/s)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) impossible)
								(begin
									(if (> 3 (+ (ai_living_count 1_station) (ai_living_count 1_tower) (ai_living_count 1_base)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 1_migration/station)
										(ai_teleport_to_starting_location 1_migration/station)
										(ai_migrate 1_migration/station 1_station/s)
										(ai_attack 1_station/s)									
										)							
									)
								)
							)


						
						
						
						)
					
					)	
				)
				
				
				(if (and (< (ai_living_count 1_base) 8) (not (volume_test_objects 0court (players))))
					(begin
					
						(cond
							( 
							(= (game_difficulty_get_real) easy)
								(begin
									(if (> 8 (+ (ai_living_count 1_station) (ai_living_count 1_tower) (ai_living_count 1_base)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 1_migration/base)
										(ai_teleport_to_starting_location 1_migration/base)
										(ai_migrate 1_migration/base 1_base/s)
										(ai_attack 1_base/s)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) normal)
								(begin
									(if (> 7 (+ (ai_living_count 1_station) (ai_living_count 1_tower) (ai_living_count 1_base)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 1_migration/base)
										(ai_teleport_to_starting_location 1_migration/base)
										(ai_migrate 1_migration/base 1_base/s)
										(ai_attack 1_base/s)										
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) hard)
								(begin
									(if (> 5 (+ (ai_living_count 1_station) (ai_living_count 1_tower) (ai_living_count 1_base)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 1_migration/base)
										(ai_teleport_to_starting_location 1_migration/base)
										(ai_migrate 1_migration/base 1_base/s)
										(ai_attack 1_base/s)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) impossible)
								(begin
									(if (> 3 (+ (ai_living_count 1_station) (ai_living_count 1_tower) (ai_living_count 1_base)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 1_migration/base)
										(ai_teleport_to_starting_location 1_migration/base)
										(ai_migrate 1_migration/base 1_base/s)
										(ai_attack 1_base/s)									
										)							
									)
								)
							)


						
						
						
						)
					
					)	
				)
				
			)
		)		
		
		
)
		

		



(script continuous 2_base

		(if (and (= 2 (structure_bsp_index)) (< (ai_living_count 2_base) 4) (not (volume_test_objects 2metrochrono (players)))  )
			(begin
				(wake hspawner)
				(sleep_until (< 3 (ai_living_count hspawn)) 5)
				(ai_migrate hspawn 2_base/spawn)
				(ai_teleport_to_starting_location 2_base/spawn)
				(ai_migrate 2_base/spawn 2_base/base)
				(ai_attack 2_base)
			)
		)
				;; These marines are for show and should not end up getting into a fight. They just "protect" the base.

		
)


(script continuous 3_base

		(if (= 3 (structure_bsp_index))
			(begin
			
				(if (and (< (ai_living_count 3_marinefront) 8) (volume_test_objects 3front (players)) (not (volume_test_objects 3marinefront (players))))
					(begin
					
						(cond
							( 
							(= (game_difficulty_get_real) easy)
								(begin
									(if (> 8 (+ (ai_living_count 3_marinefront) (ai_living_count 3_marineback) (ai_living_count 3_marinemid)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 3_marinefront/s)
										(ai_teleport_to_starting_location 3_marinefront/s)
										(ai_migrate 3_marinefront/s 3_marinefront/m)
										(ai_attack 3_marinefront/m)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) normal)
								(begin
									(if (> 7 (+ (ai_living_count 3_marinefront) (ai_living_count 3_marineback) (ai_living_count 3_marinemid)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 3_marinefront/s)
										(ai_teleport_to_starting_location 3_marinefront/s)
										(ai_migrate 3_marinefront/s 3_marinefront/m)
										(ai_attack 3_marinefront/m)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) hard)
								(begin
									(if (> 5 (+ (ai_living_count 3_marinefront) (ai_living_count 3_marineback) (ai_living_count 3_marinemid)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 3_marinefront/s)
										(ai_teleport_to_starting_location 3_marinefront/s)
										(ai_migrate 3_marinefront/s 3_marinefront/m)
										(ai_attack 3_marinefront/m)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) impossible)
								(begin
									(if (> 3 (+ (ai_living_count 3_marinefront) (ai_living_count 3_marineback) (ai_living_count 3_marinemid)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 3_marinefront/s)
										(ai_teleport_to_starting_location 3_marinefront/s)
										(ai_migrate 3_marinefront/s 3_marinefront/m)
										(ai_attack 3_marinefront/m)									
										)							
									)
								)
							)


						
						
						
						)
					
					)	
				)
				
				
				(if (and (< (ai_living_count 3_marinemid) 8) (volume_test_objects 3mid (players)) (not (volume_test_objects 3marinemid (players))))
					(begin
					
						(cond
							( 
							(= (game_difficulty_get_real) easy)
								(begin
									(if (> 8 (+ (ai_living_count 3_marinefront) (ai_living_count 3_marineback) (ai_living_count 3_marinemid)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 3_marinemid/s)
										(ai_teleport_to_starting_location 3_marinemid/s)
										(ai_migrate 3_marinemid/s 3_marinemid/m)
										(ai_attack 3_marinemid/m)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) normal)
								(begin
									(if (> 7 (+ (ai_living_count 3_marinefront) (ai_living_count 3_marineback) (ai_living_count 3_marinemid)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 3_marinemid/s)
										(ai_teleport_to_starting_location 3_marinemid/s)
										(ai_migrate 3_marinemid/s 3_marinemid/m)
										(ai_attack 3_marinemid/m)										
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) hard)
								(begin
									(if (> 5 (+ (ai_living_count 3_marinefront) (ai_living_count 3_marineback) (ai_living_count 3_marinemid)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 3_marinemid/s)
										(ai_teleport_to_starting_location 3_marinemid/s)
										(ai_migrate 3_marinemid/s 3_marinemid/m)
										(ai_attack 3_marinemid/m)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) impossible)
								(begin
									(if (> 3 (+ (ai_living_count 3_marinefront) (ai_living_count 3_marineback) (ai_living_count 3_marinemid)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 3_marinemid/s)
										(ai_teleport_to_starting_location 3_marinemid/s)
										(ai_migrate 3_marinemid/s 3_marinemid/m)
										(ai_attack 3_marinemid/m)									
										)							
									)
								)
							)


						
						
						
						)
					
					)	
				)
				
				
				
								(if (and (< (ai_living_count 3_marineback) 5) (volume_test_objects 3back (players)) (not (volume_test_objects 3marineback (players))))
					(begin
					
						(cond
							( 
							(= (game_difficulty_get_real) easy)
								(begin
									(if (> 8 (+ (ai_living_count 3_marinefront) (ai_living_count 3_marineback) (ai_living_count 3_marinemid)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 3_marineback/s)
										(ai_teleport_to_starting_location 3_marineback/s)
										(ai_migrate 3_marineback/s 3_marineback/m)
										(ai_attack 3_marineback/m)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) normal)
								(begin
									(if (> 7 (+ (ai_living_count 3_marinefront) (ai_living_count 3_marineback) (ai_living_count 3_marinemid)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 3_marineback/s)
										(ai_teleport_to_starting_location 3_marineback/s)
										(ai_migrate 3_marineback/s 3_marineback/m)
										(ai_attack 3_marineback/m)										
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) hard)
								(begin
									(if (> 5 (+ (ai_living_count 3_marinefront) (ai_living_count 3_marineback) (ai_living_count 3_marinemid)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 3_marineback/s)
										(ai_teleport_to_starting_location 3_marineback/s)
										(ai_migrate 3_marineback/s 3_marineback/m)
										(ai_attack 3_marineback/m)										
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) impossible)
								(begin
									(if (> 3 (+ (ai_living_count 3_marinefront) (ai_living_count 3_marineback) (ai_living_count 3_marinemid)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 3_marineback/s)
										(ai_teleport_to_starting_location 3_marineback/s)
										(ai_migrate 3_marineback/s 3_marineback/m)
										(ai_attack 3_marineback/m)										
										)							
									)
								)
							)


						
						
						
						)
					
					)	
				)
						
		
		

		

				

			)
		)		
		
		
)
		


(script continuous 4base

		(if (= 4 (structure_bsp_index))
			(begin
			
				(if (and (< (ai_living_count 4_marineA) 8) (volume_test_objects 4a (players)) (not (volume_test_objects 4marineA (players))))
					(begin
					
						(cond
							( 
							(= (game_difficulty_get_real) easy)
								(begin
									(if (> 8 (+ (ai_living_count 4_marineA) (ai_living_count 4_marineC) (ai_living_count 4_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 4_marineA/s)
										(ai_teleport_to_starting_location 4_marineA/s)
										(ai_migrate 4_marineA/s 4_marineA/m)
										(ai_attack 4_marineA/m)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) normal)
								(begin
									(if (> 7 (+ (ai_living_count 4_marineA) (ai_living_count 4_marineC) (ai_living_count 4_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 4_marineA/s)
										(ai_teleport_to_starting_location 4_marineA/s)
										(ai_migrate 4_marineA/s 4_marineA/m)
										(ai_attack 4_marineA/m)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) hard)
								(begin
									(if (> 5 (+ (ai_living_count 4_marineA) (ai_living_count 4_marineC) (ai_living_count 4_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 4_marineA/s)
										(ai_teleport_to_starting_location 4_marineA/s)
										(ai_migrate 4_marineA/s 4_marineA/m)
										(ai_attack 4_marineA/m)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) impossible)
								(begin
									(if (> 3 (+ (ai_living_count 4_marineA) (ai_living_count 4_marineC) (ai_living_count 4_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 4_marineA/s)
										(ai_teleport_to_starting_location 4_marineA/s)
										(ai_migrate 4_marineA/s 4_marineA/m)
										(ai_attack 4_marineA/m)									
										)							
									)
								)
							)


						
						
						
						)
					
					)	
				)
				
				
				(if (and (< (ai_living_count 4_marineB) 8) (volume_test_objects 4B (players)) (not (volume_test_objects 4marineB (players))))
					(begin
					
						(cond
							( 
							(= (game_difficulty_get_real) easy)
								(begin
									(if (> 8 (+ (ai_living_count 4_marineA) (ai_living_count 4_marineC) (ai_living_count 4_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 4_marineB/s)
										(ai_teleport_to_starting_location 4_marineB/s)
										(ai_migrate 4_marineB/s 4_marineB/m)
										(ai_attack 4_marineB/m)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) normal)
								(begin
									(if (> 7 (+ (ai_living_count 4_marineA) (ai_living_count 4_marineC) (ai_living_count 4_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 4_marineB/s)
										(ai_teleport_to_starting_location 4_marineB/s)
										(ai_migrate 4_marineB/s 4_marineB/m)
										(ai_attack 4_marineB/m)										
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) hard)
								(begin
									(if (> 5 (+ (ai_living_count 4_marineA) (ai_living_count 4_marineC) (ai_living_count 4_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 4_marineB/s)
										(ai_teleport_to_starting_location 4_marineB/s)
										(ai_migrate 4_marineB/s 4_marineB/m)
										(ai_attack 4_marineB/m)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) impossible)
								(begin
									(if (> 3 (+ (ai_living_count 4_marineA) (ai_living_count 4_marineC) (ai_living_count 4_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 4_marineB/s)
										(ai_teleport_to_starting_location 4_marineB/s)
										(ai_migrate 4_marineB/s 4_marineB/m)
										(ai_attack 4_marineB/m)									
										)							
									)
								)
							)


						
						
						
						)
					
					)	
				)
				
				
				
				(if (and (< (ai_living_count 4_marineC) 5) (volume_test_objects 4C (players)) (not (volume_test_objects 4marineB (players))))
					(begin
					
						(cond
							( 
							(= (game_difficulty_get_real) easy)
								(begin
									(if (> 8 (+ (ai_living_count 4_marineA) (ai_living_count 4_marineC) (ai_living_count 4_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 4_marineC/s)
										(ai_teleport_to_starting_location 4_marineC/s)
										(ai_migrate 4_marineC/s 4_marineC/m)
										(ai_attack 4_marineC/m)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) normal)
								(begin
									(if (> 7 (+ (ai_living_count 4_marineA) (ai_living_count 4_marineC) (ai_living_count 4_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 4_marineC/s)
										(ai_teleport_to_starting_location 4_marineC/s)
										(ai_migrate 4_marineC/s 4_marineC/m)
										(ai_attack 4_marineC/m)										
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) hard)
								(begin
									(if (> 5 (+ (ai_living_count 4_marineA) (ai_living_count 4_marineC) (ai_living_count 4_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 4_marineC/s)
										(ai_teleport_to_starting_location 4_marineC/s)
										(ai_migrate 4_marineC/s 4_marineC/m)
										(ai_attack 4_marineC/m)										
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) impossible)
								(begin
									(if (> 3 (+ (ai_living_count 4_marineA) (ai_living_count 4_marineC) (ai_living_count 4_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 4_marineC/s)
										(ai_teleport_to_starting_location 4_marineC/s)
										(ai_migrate 4_marineC/s 4_marineC/m)
										(ai_attack 4_marineC/m)										
										)							
									)
								)
							)


						
						
						
						)
					
					)	
				)
						
		
		

		

				

			)
		)		
		
		
)




(script continuous 5base

		(if (= 5 (structure_bsp_index))
			(begin
			
				
				
				
				(if (and (< (ai_living_count 5_marineB) 8) (or (volume_test_objects 5B (players)) (volume_test_objects 5C (players))) (not (volume_test_objects 5marineB (players))))
					(begin
					
						(cond
							( 
							(= (game_difficulty_get_real) easy)
								(begin
									(if (> 8 (+ (ai_living_count 4_marineA) (ai_living_count 5_marineA) (ai_living_count 5_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 5_marineB/s)
										(ai_teleport_to_starting_location 5_marineB/s)
										(ai_migrate 5_marineB/s 5_marineB/m)
										(ai_attack 5_marineB/m)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) normal)
								(begin
									(if (> 7 (+ (ai_living_count 4_marineA) (ai_living_count 5_marineA) (ai_living_count 5_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 5_marineB/s)
										(ai_teleport_to_starting_location 5_marineB/s)
										(ai_migrate 5_marineB/s 5_marineB/m)
										(ai_attack 5_marineB/m)										
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) hard)
								(begin
									(if (> 5 (+ (ai_living_count 4_marineA) (ai_living_count 5_marineA) (ai_living_count 5_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 5_marineB/s)
										(ai_teleport_to_starting_location 5_marineB/s)
										(ai_migrate 5_marineB/s 5_marineB/m)
										(ai_attack 5_marineB/m)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) impossible)
								(begin
									(if (> 3 (+ (ai_living_count 4_marineA) (ai_living_count 5_marineA) (ai_living_count 5_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 5_marineB/s)
										(ai_teleport_to_starting_location 5_marineB/s)
										(ai_migrate 5_marineB/s 5_marineB/m)
										(ai_attack 5_marineB/m)									
										)							
									)
								)
							)


						
						
						
						)
					
					)	
				)
				
				
				
				(if (and (< (ai_living_count 5_marineA) 5) (volume_test_objects 5A (players)) (not (volume_test_objects 5marineA (players))))
					(begin
					
						(cond
							( 
							(= (game_difficulty_get_real) easy)
								(begin
									(if (> 8 (+ (ai_living_count 4_marineA) (ai_living_count 5_marineA) (ai_living_count 5_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 5_marineA/s)
										(ai_teleport_to_starting_location 5_marineA/s)
										(ai_migrate 5_marineA/s 5_marineA/m)
										(ai_attack 5_marineA/m)									
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) normal)
								(begin
									(if (> 7 (+ (ai_living_count 4_marineA) (ai_living_count 5_marineA) (ai_living_count 5_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 5_marineA/s)
										(ai_teleport_to_starting_location 5_marineA/s)
										(ai_migrate 5_marineA/s 5_marineA/m)
										(ai_attack 5_marineA/m)										
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) hard)
								(begin
									(if (> 5 (+ (ai_living_count 4_marineA) (ai_living_count 5_marineA) (ai_living_count 5_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 5_marineA/s)
										(ai_teleport_to_starting_location 5_marineA/s)
										(ai_migrate 5_marineA/s 5_marineA/m)
										(ai_attack 5_marineA/m)										
										)							
									)
								)
							)
							
							( 
							(= (game_difficulty_get_real) impossible)
								(begin
									(if (> 3 (+ (ai_living_count 4_marineA) (ai_living_count 5_marineA) (ai_living_count 5_marineB)))
										(begin
										(wake hspawner)
										(sleep_until (< 3 (ai_living_count hspawn)) 5)
										(ai_migrate hspawn 5_marineA/s)
										(ai_teleport_to_starting_location 5_marineA/s)
										(ai_migrate 5_marineA/s 5_marineA/m)
										(ai_attack 5_marineA/m)										
										)							
									)
								)
							)


						
						
						
						)
					
					)	
				)
						
		
		

		

				

			)
		)		
		
		
)









;;
;;
;; The following scripts control the warthog and banshee spawns
;; Ghosts and Wraiths are placed in the map by dropships, but warthogs
;; and the banshees instead spawn when the player isn't able to see them.
;;
;;






(script continuous 2_banshees
	
	(sleep_until (= 2 (structure_bsp_index)) 5)
	
		(if (and (= 2 (structure_bsp_index))(< -1 (unit_get_health sheea)))
				(begin
					(if (not (vehicle_test_seat_list sheea "B-driver" (ai_actors 2_mombasashee)))
						(begin
							(vehicle_unload sheea "")
							(sleep 5)
							(unit_kill sheea)
							(object_destroy sheea)
						)
					)
				)
		)
		
		(if (and (= 2 (structure_bsp_index))(< -1 (unit_get_health sheeb)))
				(begin
					(if (not (vehicle_test_seat_list sheeb "B-driver" (ai_actors 2_mombasashee)))
						(begin
							(vehicle_unload sheeb "")
							(sleep 5)
							(unit_kill sheeb)
							(object_destroy sheeb)
						)
					)
				)
		)
	
	
		(if (and (= 2 (structure_bsp_index))(< -1 (unit_get_health sheec)))
			(begin
				(if (not (vehicle_test_seat_list sheec "B-driver" (ai_actors 2_chronoshee)))
					(begin
						(vehicle_unload sheec "")
						(sleep 5)
						(unit_kill sheec)
						(object_destroy sheec)
					)
				)
			)
		)
		
		(if (and (= 2 (structure_bsp_index))(< -1 (unit_get_health sheed)))
			(begin
				(if (not (vehicle_test_seat_list sheed "B-driver" (ai_actors 2_chronoshee)))
					(begin
						(vehicle_unload sheed "")
						(sleep 5)
						(unit_kill sheed)
						(object_destroy sheed)
					)
				)
			)
		)

		
		(if (and (= 2 (structure_bsp_index)) (or (> 0 (unit_get_health sheea)) (> 0 (unit_get_health sheeb)) ) (or (volume_test_objects 2mombafront (players)) (volume_test_objects 2mombaback (players))) )
			(begin
				(if (volume_test_objects 2mombafront (players))
					(begin
						(if (> 0 (unit_get_health sheeb))
							(begin
								(ai_place driver/banshee)
								(sleep 1)
								(object_create_anew sheeb)
								(sleep 1)
								(vehicle_load_magic sheeb "" (ai_actors driver/banshee))
								(sleep_until (vehicle_test_seat_list sheeb "B-driver" (ai_actors driver/banshee)) 5)
								(ai_migrate driver/banshee 2_mombasashee)
								(object_teleport sheeb 2_bflagb)
								(recording_play sheeb 2_newmombasaB2)
								(sleep_until (> 1325 (recording_time sheeb)) 5)
								(recording_kill sheeb)
							)				
						)
						(if (> 0 (unit_get_health sheea))
							(begin
								(ai_place driver/banshee)
								(sleep 1)
								(object_create_anew sheea)
								(sleep 1)
								(vehicle_load_magic sheea "" (ai_actors driver/banshee))
								(sleep_until (vehicle_test_seat_list sheea "B-driver" (ai_actors driver/banshee)) 5)
								(ai_migrate driver/banshee 2_mombasashee)
								(object_teleport sheea 2_bflagb)
								(recording_play sheea 2_newmombasaB2)
								(sleep_until (> 1325 (recording_time sheea)) 5)
								(recording_kill sheea)
							)				
						)
					)
				)
				(if (volume_test_objects 2mombaback (players))
					(begin
						(if (> 0 (unit_get_health sheeb))
							(begin
								(ai_place driver/banshee)
								(sleep 1)
								(object_create_anew sheeb)
								(sleep 1)
								(vehicle_load_magic sheeb "" (ai_actors driver/banshee))
								(sleep_until (vehicle_test_seat_list sheeb "B-driver" (ai_actors driver/banshee)) 5)
								(ai_migrate driver/banshee 2_mombasashee)
								(object_teleport sheeb 2_bflaga)
								(recording_play sheeb 2_newmombasaA1)
								(sleep_until (> 1325 (recording_time sheeb)) 5)
								(recording_kill sheeb)
							)				
						)
						(if (> 0 (unit_get_health sheea))
							(begin
								(ai_place driver/banshee)
								(sleep 1)
								(object_create_anew sheea)
								(sleep 1)
								(vehicle_load_magic sheea "" (ai_actors driver/banshee))
								(sleep_until (vehicle_test_seat_list sheea "B-driver" (ai_actors driver/banshee)) 5)
								(ai_migrate driver/banshee 2_mombasashee)
								(object_teleport sheea 2_bflaga)
								(recording_play sheea 2_newmombasaA1)
								(sleep_until (> 1325 (recording_time sheea)) 5)
								(recording_kill sheea)
							)				
						)
					)
					
				)
			)
		)
		
		(if (and (= 2 (structure_bsp_index)) (or (> 0 (unit_get_health sheed)) (> 0 (unit_get_health sheec)) ) (volume_test_objects 2chronopolis (players)) )
			(begin
				(if (volume_test_objects 2chronobox (players))
						(begin
						
							(if (> 0 (unit_get_health sheed))
								(begin
									(ai_place driver/banshee)
									(sleep 1)
									(object_create_anew sheed)
									(sleep 1)
									(vehicle_load_magic sheed "B-driver" (ai_actors driver/banshee))
									(sleep_until (vehicle_test_seat_list sheed "B-driver" (ai_actors driver/banshee)) 5)
									(ai_migrate driver/banshee 2_chronoshee)
									(object_teleport sheed 2_bflagd)
									(recording_play sheed 2_chronoB1)
									(sleep_until (> 1700 (recording_time sheed)) 5)
									(recording_kill sheed)
								)				
							)
							(if (> 0 (unit_get_health sheec))
								(begin
									(ai_place driver/banshee)
									(sleep 1)
									(object_create_anew sheec)
									(sleep 1)
									(vehicle_load_magic sheec "B-driver" (ai_actors driver/banshee))
									(sleep_until (vehicle_test_seat_list sheec "B-driver" (ai_actors driver/banshee)) 5)
									(ai_migrate driver/banshee 2_chronoshee)
									(object_teleport sheec 2_bflagd)
									(recording_play sheec 2_chronoB1)
									(sleep_until (> 1700 (recording_time sheec)) 5)
									(recording_kill sheec)
									
								)				
							)
						)
				)
				(if (and (volume_test_objects 2chronopolis (players)) (not (volume_test_objects 2chronobox (players))))
						(begin
							(if (> 0 (unit_get_health sheed))
								(begin
									(ai_place driver/banshee)
									(sleep 1)
									(object_create_anew sheed)
									(sleep 1)
									(vehicle_load_magic sheed "B-driver" (ai_actors driver/banshee))
									(sleep_until (vehicle_test_seat_list sheed "B-driver" (ai_actors driver/banshee)) 5)
									(ai_migrate driver/banshee 2_chronoshee)
									(object_teleport sheed 2_bflagc)
									(recording_play sheed 2_loading1)
									(sleep_until (> 1450 (recording_time sheed)) 5)
									(recording_kill sheed)
								)				
							)
							(if (> 0 (unit_get_health sheec))
								(begin
									(ai_place driver/banshee)
									(sleep 1)
									(object_create_anew sheec)
									(sleep 1)
									(vehicle_load_magic sheec "B-driver" (ai_actors driver/banshee))
									(sleep_until (vehicle_test_seat_list sheec "B-driver" (ai_actors driver/banshee)) 5)
									(ai_migrate driver/banshee 2_chronoshee)
									(object_teleport sheec 2_bflagC)
									(recording_play sheec 2_loading1)
									(sleep_until (> 1450 (recording_time sheec)) 5)
									(recording_kill sheec)
								)				
							)
						)
						
					)
				)
		)
		(sleep 1800)
)
	

(script continuous 2_warthog
	(sleep 90)
	(sleep_until (= 2 (structure_bsp_index)) 5)
	
		(if (and (= 2 (structure_bsp_index))(= 0 (unit_get_health mhoga)))
			(begin
				(if (not (vehicle_test_seat_list mhoga "M-driver" (ai_actors 2_mombasamarine/driver)))
					(begin
						(vehicle_unload mhoga "")
						(sleep 5)
						(unit_kill mhoga)
						(object_destroy mhoga)
					)
				)
			)
		)
		
		(if (and (= 2 (structure_bsp_index))(= 0 (unit_get_health mhogb)))
			(begin
				(if (not (vehicle_test_seat_list mhogb "M-driver" (ai_actors 2_mombasamarine/driver)))
					(begin
						(vehicle_unload mhogb "")
						(sleep 5)
						(unit_kill mhogb)
						(object_destroy mhogb)
					)
				)
			)
		)
		
		(if (and (= 2 (structure_bsp_index))(= 0 (unit_get_health mhogc)))
			(begin
				(if (not (vehicle_test_seat_list mhogc "M-driver" (ai_actors 2_chronomarine/driver)))
					(begin
						(vehicle_unload mhogc "")
						(sleep 5)
						(unit_kill mhogc)
						(object_destroy mhogc)
					)
				)
			)
		)
		
		
		(if (and (= 2 (structure_bsp_index))(= 0 (unit_get_health mhogd)))
			(begin
				(if (not (vehicle_test_seat_list mhogd "M-driver" (ai_actors 2_chronomarine/driver)))
					(begin
						(vehicle_unload mhogd "")
						(sleep 5)
						(unit_kill mhogd)
						(object_destroy mhogd)
					)
				)
			)
		)
		
		(if (and (= 2 (structure_bsp_index)) (or (> 0 (unit_get_health mhoga)) (> 0 (unit_get_health mhogb)) ) (or (volume_test_objects 2mombafront (players)) (volume_test_objects 2mombaback (players))) )
			(begin
				(if (volume_test_objects 2mombaback (players))
					(begin
						(cond
							((> 0 (unit_get_health mhoga))
								(begin
						
									(ai_place warthog_ai/driver)
									(sleep 1)
									(object_create_anew mhoga)
									(sleep 1)
									(vehicle_load_magic mhoga "driver" (ai_actors warthog_ai/driver))
									(sleep_until (vehicle_test_seat_list mhoga "M-driver" (ai_actors warthog_ai/driver)) 5)
									(ai_migrate warthog_ai/driver 2_mombasamarine/driver)
									(ai_place warthog_ai/passenger)
									(ai_place warthog_ai/passenger)
									(sleep 1)
									(vehicle_load_magic mhoga "" (ai_actors warthog_ai/passenger))
									(ai_migrate warthog_ai/passenger 2_mombasamarine/warthog)
									(object_teleport mhoga 2_vflaga)
								)
							)
							
							((> 0 (unit_get_health mhogb))
								(begin
									(ai_place warthog_ai/driver)
									(sleep 1)
									(object_create_anew mhogb)
									(sleep 1)
									(vehicle_load_magic mhogb "driver" (ai_actors warthog_ai/driver))
									(sleep_until (vehicle_test_seat_list mhogb "M-driver" (ai_actors warthog_ai/driver)) 5)
									(ai_migrate warthog_ai/driver 2_mombasamarine/driver)
									(ai_place warthog_ai/passenger)
									(ai_place warthog_ai/passenger)
									(sleep 1)
									(vehicle_load_magic mhogb "" (ai_actors warthog_ai/passenger))
									(ai_migrate warthog_ai/passenger 2_mombasamarine/warthog)
									(object_teleport mhogb 2_vflaga)							
								)
							)
						)
					)
				)
				(if (volume_test_objects 2mombafront (players))
					(begin
						(cond
							((> 0 (unit_get_health mhoga))
								(begin
						
									(ai_place warthog_ai/driver)
									(sleep 1)
									(object_create_anew mhoga)
									(sleep 1)
									(vehicle_load_magic mhoga "driver" (ai_actors warthog_ai/driver))
									(sleep_until (vehicle_test_seat_list mhoga "M-driver" (ai_actors warthog_ai/driver)) 5)
									(ai_migrate warthog_ai/driver 2_mombasamarine/driver)
									(ai_place warthog_ai/passenger)
									(ai_place warthog_ai/passenger)
									(sleep 1)
									(vehicle_load_magic mhoga "" (ai_actors warthog_ai/passenger))
									(ai_migrate warthog_ai/passenger 2_mombasamarine/warthog)
									(object_teleport mhoga 2_vflagb)
								)
							)
							
							((> 0 (unit_get_health mhogb))
								(begin
									(ai_place warthog_ai/driver)
									(sleep 1)
									(object_create_anew mhogb)
									(sleep 1)
									(vehicle_load_magic mhogb "driver" (ai_actors warthog_ai/driver))
									(sleep_until (vehicle_test_seat_list mhogb "M-driver" (ai_actors warthog_ai/driver)) 5)
									(ai_migrate warthog_ai/driver 2_mombasamarine/driver)
									(ai_place warthog_ai/passenger)
									(ai_place warthog_ai/passenger)
									(sleep 1)
									(vehicle_load_magic mhogb "" (ai_actors warthog_ai/passenger))
									(ai_migrate warthog_ai/passenger 2_mombasamarine/warthog)
									(object_teleport mhogb 2_vflagb)							
								)
							)
						)
					)
				)
		
			)
		)
		
		(if (and (= 2 (structure_bsp_index)) (or (> 0 (unit_get_health mhogc)) (> 0 (unit_get_health mhogd)) ) (volume_test_objects 2chronopolis (players)) )
			(begin
				(if (volume_test_objects 2chronobox (players))
					(begin
						(cond
							((> 0 (unit_get_health mhogc))
								(begin
						
									(ai_place warthog_ai/driver)
									(sleep 1)
									(object_create_anew mhogc)
									(sleep 1)
									(vehicle_load_magic mhogc "driver" (ai_actors warthog_ai/driver))
									(sleep_until (vehicle_test_seat_list mhogc "M-driver" (ai_actors warthog_ai/driver)) 5)
									(ai_migrate warthog_ai/driver 2_chronomarine/driver)
									(ai_place warthog_ai/passenger)
									(ai_place warthog_ai/passenger)
									(sleep 1)
									(vehicle_load_magic mhogc "" (ai_actors warthog_ai/passenger))
									(ai_migrate warthog_ai/passenger 2_chronomarine/warthog)
									(object_teleport mhogc 2_vflagc)
								)
							)
							
							((> 0 (unit_get_health mhogd))
								(begin
									(ai_place warthog_ai/driver)
									(sleep 1)
									(object_create_anew mhogd)
									(sleep 1)
									(vehicle_load_magic mhogd "driver" (ai_actors warthog_ai/driver))
									(sleep_until (vehicle_test_seat_list mhogd "M-driver" (ai_actors warthog_ai/driver)) 5)
									(ai_migrate warthog_ai/driver 2_chronomarine/driver)
									(ai_place warthog_ai/passenger)
									(ai_place warthog_ai/passenger)
									(sleep 1)
									(vehicle_load_magic mhogd "" (ai_actors warthog_ai/passenger))
									(ai_migrate warthog_ai/passenger 2_chronomarine/warthog)
									(object_teleport mhogd 2_vflagc)							
								)
							)
						)
					)
					(begin				;;this is the ELSE half, which gets played if the player is not in chronobox.
						(cond
							((> 0 (unit_get_health mhogc))
								(begin
						
									(ai_place warthog_ai/driver)
									(sleep 1)
									(object_create_anew mhogc)
									(sleep 1)
									(vehicle_load_magic mhogc "driver" (ai_actors warthog_ai/driver))
									(sleep_until (vehicle_test_seat_list mhogc "M-driver" (ai_actors warthog_ai/driver)) 5)
									(ai_migrate warthog_ai/driver 2_chronomarine/driver)
									(ai_place warthog_ai/passenger)
									(ai_place warthog_ai/passenger)
									(sleep 1)
									(vehicle_load_magic mhogc "" (ai_actors warthog_ai/passenger))
									(ai_migrate warthog_ai/passenger 2_chronomarine/warthog)
									(object_teleport mhogc 2_vflagd)
								)
							)
							
							((> 0 (unit_get_health mhogd))
								(begin
									(ai_place warthog_ai/driver)
									(sleep 1)
									(object_create_anew mhogd)
									(sleep 1)
									(vehicle_load_magic mhogd "driver" (ai_actors warthog_ai/driver))
									(sleep_until (vehicle_test_seat_list mhogd "M-driver" (ai_actors warthog_ai/driver)) 5)
									(ai_migrate warthog_ai/driver 2_chronomarine/driver)
									(ai_place warthog_ai/passenger)
									(ai_place warthog_ai/passenger)
									(sleep 1)
									(vehicle_load_magic mhogd "" (ai_actors warthog_ai/passenger))
									(ai_migrate warthog_ai/passenger 2_chronomarine/warthog)
									(object_teleport mhogd 2_vflagd)							
								)
							)
						)
					)
				)
			
			)
		)
)


(script continuous 3warthog
	(sleep 90)
	(sleep_until (= 3 (structure_bsp_index)) 5)
	
		(if (and (= 3 (structure_bsp_index))(= 0 (unit_get_health mhoga)))
			(begin
				(if (not (vehicle_test_seat_list mhoga "M-driver" (ai_actors 3_warthog/driver)))
					(begin
						(vehicle_unload mhoga "")
						(sleep 5)
						(unit_kill mhoga)
						(object_destroy mhoga)
					)
				)
			)
		)
		
		(if (and (= 3 (structure_bsp_index))(= 0 (unit_get_health mhogb)))
			(begin
				(if (not (vehicle_test_seat_list mhogb "M-driver" (ai_actors 3_warthog/driver)))
					(begin
						(vehicle_unload mhogb "")
						(sleep 5)
						(unit_kill mhogb)
						(object_destroy mhogb)
					)
				)
			)
		)
		
		(if (and (= 3 (structure_bsp_index)) (or (> 0 (unit_get_health mhoga)) (> 0 (unit_get_health mhogb)) ))
			(begin
				(if (not (volume_test_objects 3front (players)))
					(begin
						(cond
							((> 0 (unit_get_health mhoga))
								(begin
						
									(ai_place warthog_ai/driver)
									(sleep 1)
									(object_create_anew mhoga)
									(sleep 1)
									(vehicle_load_magic mhoga "driver" (ai_actors warthog_ai/driver))
									(sleep_until (vehicle_test_seat_list mhoga "M-driver" (ai_actors warthog_ai/driver)) 5)
									(ai_migrate warthog_ai/driver 3_warthog/driver)
									(ai_place warthog_ai/passenger)
									(ai_place warthog_ai/passenger)
									(sleep 1)
									(vehicle_load_magic mhoga "" (ai_actors warthog_ai/passenger))
									(ai_migrate warthog_ai/passenger 3_warthog/warthog)
									(object_teleport mhoga 3_vflaga)
								)
							)
							
							((> 0 (unit_get_health mhogb))
								(begin
									(ai_place warthog_ai/driver)
									(sleep 1)
									(object_create_anew mhogb)
									(sleep 1)
									(vehicle_load_magic mhogb "driver" (ai_actors warthog_ai/driver))
									(sleep_until (vehicle_test_seat_list mhogb "M-driver" (ai_actors warthog_ai/driver)) 5)
									(ai_migrate warthog_ai/driver 3_warthog/driver)
									(ai_place warthog_ai/passenger)
									(ai_place warthog_ai/passenger)
									(sleep 1)
									(vehicle_load_magic mhogb "" (ai_actors warthog_ai/passenger))
									(ai_migrate warthog_ai/passenger 3_warthog/warthog)
									(object_teleport mhogb 3_vflaga)							
								)
							)
						)
					)
				)
				(if (not (volume_test_objects 3back (players)))
					(begin
						(cond
							((> 0 (unit_get_health mhoga))
								(begin
						
									(ai_place warthog_ai/driver)
									(sleep 1)
									(object_create_anew mhoga)
									(sleep 1)
									(vehicle_load_magic mhoga "driver" (ai_actors warthog_ai/driver))
									(sleep_until (vehicle_test_seat_list mhoga "M-driver" (ai_actors warthog_ai/driver)) 5)
									(ai_migrate warthog_ai/driver 3_warthog/driver)
									(ai_place warthog_ai/passenger)
									(ai_place warthog_ai/passenger)
									(sleep 1)
									(vehicle_load_magic mhoga "" (ai_actors warthog_ai/passenger))
									(ai_migrate warthog_ai/passenger 3_warthog/warthog)
									(object_teleport mhoga 3_vflagb)
								)
							)
							
							((> 0 (unit_get_health mhogb))
								(begin
									(ai_place warthog_ai/driver)
									(sleep 1)
									(object_create_anew mhogb)
									(sleep 1)
									(vehicle_load_magic mhogb "driver" (ai_actors warthog_ai/driver))
									(sleep_until (vehicle_test_seat_list mhogb "M-driver" (ai_actors warthog_ai/driver)) 5)
									(ai_migrate warthog_ai/driver 3_warthog/driver)
									(ai_place warthog_ai/passenger)
									(ai_place warthog_ai/passenger)
									(sleep 1)
									(vehicle_load_magic mhogb "" (ai_actors warthog_ai/passenger))
									(ai_migrate warthog_ai/passenger 3_warthog/warthog)
									(object_teleport mhogb 3_vflagb)							
								)
							)
						)
					)
				)
		
			)
		)		
)


(script continuous 4warthog
	(sleep 90)
	(sleep_until (= 4 (structure_bsp_index)) 5)
	
		(if (and (= 4 (structure_bsp_index))(= 0 (unit_get_health mhoga)))
			(begin
				(if (not (vehicle_test_seat_list mhoga "M-driver" (ai_actors 4_bridgehog/driver)))
					(begin
						(vehicle_unload mhoga "")
						(sleep 5)
						(unit_kill mhoga)
						(object_destroy mhoga)
					)
				)
			)
		)
		
		(if (and (= 4 (structure_bsp_index))(= 0 (unit_get_health mhogb)))
			(begin
				(if (not (vehicle_test_seat_list mhogb "M-driver" (ai_actors 4_bridgehog/driver)))
					(begin
						(vehicle_unload mhogb "")
						(sleep 5)
						(unit_kill mhogb)
						(object_destroy mhogb)
					)
				)
			)
		)
		
		(if (and (= 4 (structure_bsp_index))(= 0 (unit_get_health mhogc)))
			(begin
				(if (not (vehicle_test_seat_list mhogc "M-driver" (ai_actors 4_bridgehog/driver)))
					(begin
						(vehicle_unload mhogc "")
						(sleep 5)
						(unit_kill mhogc)
						(object_destroy mhogc)
					)
				)
			)
		)

		(if (and (= 4 (structure_bsp_index))(= 0 (unit_get_health mhogd)))
			(begin
				(if (not (vehicle_test_seat_list mhogd "M-driver" (ai_actors 4_bridgehog/driver)))
					(begin
						(vehicle_unload mhogd "")
						(sleep 5)
						(unit_kill mhogd)
						(object_destroy mhogd)
					)
				)
			)
		)
		
		
		
		
		
		
		(if (and (= 4 (structure_bsp_index)) (or (> 0 (unit_get_health mhoga)) (> 0 (unit_get_health mhogb)) ))
			(begin
			
				(if (or (volume_test_objects 4front (players)) (volume_test_objects 4mid (players)) (volume_test_objects 4back (players)))
					(begin
					
						(if (not (volume_test_objects 4front (players)))
							(begin
								(cond
									((> 0 (unit_get_health mhoga))
										(begin
								
											(ai_place warthog_ai/driver)
											(sleep 1)
											(object_create_anew mhoga)
											(sleep 1)
											(vehicle_load_magic mhoga "driver" (ai_actors warthog_ai/driver))
											(sleep_until (vehicle_test_seat_list mhoga "M-driver" (ai_actors warthog_ai/driver)) 5)
											(ai_migrate warthog_ai/driver 4_bridgehog/driver)
											(ai_place warthog_ai/passenger)
											(ai_place warthog_ai/passenger)
											(sleep 1)
											(vehicle_load_magic mhoga "" (ai_actors warthog_ai/passenger))
											(ai_migrate warthog_ai/passenger 4_bridgehog/passenger)
											(object_teleport mhoga 4_vflagc)
										)
									)
									
									((> 0 (unit_get_health mhogb))
										(begin
											(ai_place warthog_ai/driver)
											(sleep 1)
											(object_create_anew mhogb)
											(sleep 1)
											(vehicle_load_magic mhogb "driver" (ai_actors warthog_ai/driver))
											(sleep_until (vehicle_test_seat_list mhogb "M-driver" (ai_actors warthog_ai/driver)) 5)
											(ai_migrate warthog_ai/driver 4_bridgehog/driver)
											(ai_place warthog_ai/passenger)
											(ai_place warthog_ai/passenger)
											(sleep 1)
											(vehicle_load_magic mhogb "" (ai_actors warthog_ai/passenger))
											(ai_migrate warthog_ai/passenger 4_bridgehog/passenger)
											(object_teleport mhogb 4_vflagc)							
										)
									)
									
									
									
									
								)
							)
						)
						(if (not (volume_test_objects 4back (players)))
							(begin
								(cond
									((> 0 (unit_get_health mhoga))
										(begin
								
											(ai_place warthog_ai/driver)
											(sleep 1)
											(object_create_anew mhoga)
											(sleep 1)
											(vehicle_load_magic mhoga "driver" (ai_actors warthog_ai/driver))
											(sleep_until (vehicle_test_seat_list mhoga "M-driver" (ai_actors warthog_ai/driver)) 5)
											(ai_migrate warthog_ai/driver 4_bridgehog/driver)
											(ai_place warthog_ai/passenger)
											(ai_place warthog_ai/passenger)
											(sleep 1)
											(vehicle_load_magic mhoga "" (ai_actors warthog_ai/passenger))
											(ai_migrate warthog_ai/passenger 4_bridgehog/passenger)
											(object_teleport mhoga 4_vflagd)
										)
									)
									
									((> 0 (unit_get_health mhogb))
										(begin
											(ai_place warthog_ai/driver)
											(sleep 1)
											(object_create_anew mhogb)
											(sleep 1)
											(vehicle_load_magic mhogb "driver" (ai_actors warthog_ai/driver))
											(sleep_until (vehicle_test_seat_list mhogb "M-driver" (ai_actors warthog_ai/driver)) 5)
											(ai_migrate warthog_ai/driver 4_bridgehog/driver)
											(ai_place warthog_ai/passenger)
											(ai_place warthog_ai/passenger)
											(sleep 1)
											(vehicle_load_magic mhogb "" (ai_actors warthog_ai/passenger))
											(ai_migrate warthog_ai/passenger 4_bridgehog/passenger)
											(object_teleport mhogb 4_vflagd)							
										)
									)	
									
								)
							)
						)
				
					)
				)
				
				(if (or (volume_test_objects 4a (players)) (volume_test_objects 4b (players)) (volume_test_objects 4c (players)))
					(begin
					
						(if (not (volume_test_objects 4a (players)))
							(begin
								(cond
									((> 0 (unit_get_health mhogc))
										(begin
								
											(ai_place warthog_ai/driver)
											(sleep 1)
											(object_create_anew mhogc)
											(sleep 1)
											(vehicle_load_magic mhogc "driver" (ai_actors warthog_ai/driver))
											(sleep_until (vehicle_test_seat_list mhogc "M-driver" (ai_actors warthog_ai/driver)) 5)
											(ai_migrate warthog_ai/driver 4_bridgehog/driver)
											(ai_place warthog_ai/passenger)
											(ai_place warthog_ai/passenger)
											(sleep 1)
											(vehicle_load_magic mhogc "" (ai_actors warthog_ai/passenger))
											(ai_migrate warthog_ai/passenger 4_bridgehog/passenger)
											(object_teleport mhogc 4_vflaga)
										)
									)
									
									((> 0 (unit_get_health mhogd))
										(begin
											(ai_place warthog_ai/driver)
											(sleep 1)
											(object_create_anew mhogd)
											(sleep 1)
											(vehicle_load_magic mhogd "driver" (ai_actors warthog_ai/driver))
											(sleep_until (vehicle_test_seat_list mhogd "M-driver" (ai_actors warthog_ai/driver)) 5)
											(ai_migrate warthog_ai/driver 4_bridgehog/driver)
											(ai_place warthog_ai/passenger)
											(ai_place warthog_ai/passenger)
											(sleep 1)
											(vehicle_load_magic mhogd "" (ai_actors warthog_ai/passenger))
											(ai_migrate warthog_ai/passenger 4_bridgehog/passenger)
											(object_teleport mhogd 4_vflaga)							
										)
									)
									
									
									
									
								)
							)
						)
						(if (not (volume_test_objects 4c (players)))
							(begin
								(cond
									((> 0 (unit_get_health mhogc))
										(begin
								
											(ai_place warthog_ai/driver)
											(sleep 1)
											(object_create_anew mhogc)
											(sleep 1)
											(vehicle_load_magic mhogc "driver" (ai_actors warthog_ai/driver))
											(sleep_until (vehicle_test_seat_list mhogc "M-driver" (ai_actors warthog_ai/driver)) 5)
											(ai_migrate warthog_ai/driver 4_bridgehog/driver)
											(ai_place warthog_ai/passenger)
											(ai_place warthog_ai/passenger)
											(sleep 1)
											(vehicle_load_magic mhogc "" (ai_actors warthog_ai/passenger))
											(ai_migrate warthog_ai/passenger 4_bridgehog/passenger)
											(object_teleport mhogc 4_vflagb)
										)
									)
									
									((> 0 (unit_get_health mhogd))
										(begin
											(ai_place warthog_ai/driver)
											(sleep 1)
											(object_create_anew mhogd)
											(sleep 1)
											(vehicle_load_magic mhogd "driver" (ai_actors warthog_ai/driver))
											(sleep_until (vehicle_test_seat_list mhogd "M-driver" (ai_actors warthog_ai/driver)) 5)
											(ai_migrate warthog_ai/driver 4_bridgehog/driver)
											(ai_place warthog_ai/passenger)
											(ai_place warthog_ai/passenger)
											(sleep 1)
											(vehicle_load_magic mhogd "" (ai_actors warthog_ai/passenger))
											(ai_migrate warthog_ai/passenger 4_bridgehog/passenger)
											(object_teleport mhogd 4_vflagb)							
										)
									)	
									
								)
							)
						)
				
					)
				)
			)
		)
)



(script continuous 4ghosts

	(if (or (volume_test_objects 4a (players)) (volume_test_objects 4b (players)) (volume_test_objects 4c (players)))
		(begin

			(if (or (volume_test_object 4front ghosta) (volume_test_object 4mid ghosta))
				(object_destroy ghosta)
			)
			(if (or (volume_test_object 4front ghostb) (volume_test_object 4mid ghostb))
				(object_destroy ghostb)
			)
			(if (or (volume_test_object 4front ghostc) (volume_test_object 4mid ghostc))
				(object_destroy ghostc)
			)
			(if (or (volume_test_object 4front ghostd) (volume_test_object 4mid ghostd))
				(object_destroy ghostd)
			)
			(if (or (volume_test_object 4front wraitha) (volume_test_object 4mid wraitha))
				(object_destroy wraitha)
			)
			(if (or (volume_test_object 4front wraithb) (volume_test_object 4mid wraithb))
				(object_destroy wraithb)
			)
			
			

		)
	)
	
	(if (or (volume_test_objects 4front (players)) (volume_test_objects 4mid (players)) (volume_test_objects 4back (players)))
		(begin

			(if (or (volume_test_object 4a ghosta) (volume_test_object 4b ghosta))
				(object_destroy ghosta)
			)
			(if (or (volume_test_object 4a ghostb) (volume_test_object 4b ghostb))
				(object_destroy ghostb)
			)
			(if (or (volume_test_object 4a ghostc) (volume_test_object 4b ghostc))
				(object_destroy ghostc)
			)
			(if (or (volume_test_object 4a ghostd) (volume_test_object 4b ghostd))
				(object_destroy ghostd)
			)
			(if (or (volume_test_object 4a wraitha) (volume_test_object 4b wraitha))
				(object_destroy wraitha)
			)
			(if (or (volume_test_object 4a wraithb) (volume_test_object 4b wraithb))
				(object_destroy wraithb)
			)
			
			

		)
	)
	(sleep 1800)
)



(script continuous 4banshees
	
	(sleep_until (= 4 (structure_bsp_index)) 5)
	
		(if (and (= 4 (structure_bsp_index))(< -1 (unit_get_health sheea)))
				(begin
					(if (not (vehicle_test_seat_list sheea "B-driver" (ai_actors 4_bridgeshee)))
						(begin
							(vehicle_unload sheea "")
							(sleep 5)
							(unit_kill sheea)
							(object_destroy sheea)
						)
					)
				)
		)
		
		(if (and (= 4 (structure_bsp_index))(< -1 (unit_get_health sheeb)))
				(begin
					(if (not (vehicle_test_seat_list sheeb "B-driver" (ai_actors 4_bridgeshee)))
						(begin
							(vehicle_unload sheeb "")
							(sleep 5)
							(unit_kill sheeb)
							(object_destroy sheeb)
						)
					)
				)
		)
	
	
		(if (and (= 4 (structure_bsp_index))(< -1 (unit_get_health sheec)))
			(begin
				(if (not (vehicle_test_seat_list sheec "B-driver" (ai_actors 4_cityshee)))
					(begin
						(vehicle_unload sheec "")
						(sleep 5)
						(unit_kill sheec)
						(object_destroy sheec)
					)
				)
			)
		)
		
		(if (and (= 4 (structure_bsp_index))(< -1 (unit_get_health sheed)))
			(begin
				(if (not (vehicle_test_seat_list sheed "B-driver" (ai_actors 4_cityshee)))
					(begin
						(vehicle_unload sheed "")
						(sleep 5)
						(unit_kill sheed)
						(object_destroy sheed)
					)
				)
			)
		)

		
		(if (and (= 4 (structure_bsp_index)) (or (> 0 (unit_get_health sheea)) (> 0 (unit_get_health sheeb)) ) (or (volume_test_objects 4front (players)) (volume_test_objects 4mid (players)) (volume_test_objects 4back (players))) )
			(begin
				(if (or  (volume_test_objects 4front (players)) (volume_test_objects 4mid (players)))
					(begin
						(if (> 0 (unit_get_health sheeb))
							(begin
								(ai_place driver/banshee)
								(sleep 1)
								(object_create_anew sheeb)
								(sleep 1)
								(vehicle_load_magic sheeb "" (ai_actors driver/banshee))
								(sleep_until (vehicle_test_seat_list sheeb "B-driver" (ai_actors driver/banshee)) 5)
								(ai_migrate driver/banshee 4_bridgeshee)
								(object_teleport sheeb 4_trollA)
								
								(set tempint (random_range 1 3))
								
								(if (= 1 tempint)
									(begin
										(recording_play sheeb 4_trollA1)										
									)
								)
								(if (= 2 tempint)
									(begin
										(recording_play sheeb 4_trollA2)
										
									)
								)
							)				
						)
						(if (> 0 (unit_get_health sheea))
							(begin
								(ai_place driver/banshee)
								(sleep 1)
								(object_create_anew sheea)
								(sleep 1)
								(vehicle_load_magic sheea "" (ai_actors driver/banshee))
								(sleep_until (vehicle_test_seat_list sheea "B-driver" (ai_actors driver/banshee)) 5)
								(ai_migrate driver/banshee 4_bridgeshee)
								(object_teleport sheea 4_trollA)
								
								(set tempint (random_range 1 3))
								
								(if (= 1 tempint)
									(begin
										(recording_play sheea 4_trollA1)										
									)
								)
								(if (= 2 tempint)
									(begin
										(recording_play sheea 4_trollA2)
										
									)
								)
							)				
						)
					)
				)
				(if (or  (volume_test_objects 4back (players)) (volume_test_objects 4mid (players)))
					(begin
						(if (> 0 (unit_get_health sheeb))
							(begin
								(ai_place driver/banshee)
								(sleep 1)
								(object_create_anew sheeb)
								(sleep 1)
								(vehicle_load_magic sheeb "" (ai_actors driver/banshee))
								(sleep_until (vehicle_test_seat_list sheeb "B-driver" (ai_actors driver/banshee)) 5)
								(ai_migrate driver/banshee 4_bridgeshee)
								(object_teleport sheeb 4_trollB)
								
								(set tempint (random_range 1 3))
								
								(if (= 1 tempint)
									(begin
										(recording_play sheeb 4_trollB1)										
									)
								)
								(if (= 2 tempint)
									(begin
										(recording_play sheeb 4_trollB2)
										
									)
								)
							)				
						)
						(if (> 0 (unit_get_health sheea))
							(begin
								(ai_place driver/banshee)
								(sleep 1)
								(object_create_anew sheea)
								(sleep 1)
								(vehicle_load_magic sheea "" (ai_actors driver/banshee))
								(sleep_until (vehicle_test_seat_list sheea "B-driver" (ai_actors driver/banshee)) 5)
								(ai_migrate driver/banshee 4_bridgeshee)
								(object_teleport sheea 4_trollB)
								
								(set tempint (random_range 1 3))
								
								(if (= 1 tempint)
									(begin
										(recording_play sheea 4_trollB1)										
									)
								)
								(if (= 2 tempint)
									(begin
										(recording_play sheea 4_trollB2)
										
									)
								)
							)				
						)
					)
					
				)
			)
		)
		
		(if (and (= 4 (structure_bsp_index)) (or (> 0 (unit_get_health sheed)) (> 0 (unit_get_health sheec)) ) (or (volume_test_objects 4A (players)) (volume_test_objects 4B (players)) (volume_test_objects 4C (players))) )
			(begin
				(if (or  (volume_test_objects 4A (players)) (volume_test_objects 4B (players)))
						(begin
						
							(if (> 0 (unit_get_health sheed))
								(begin
									(ai_place driver/banshee)
									(sleep 1)
									(object_create_anew sheed)
									(sleep 1)
									(vehicle_load_magic sheed "B-driver" (ai_actors driver/banshee))
									(sleep_until (vehicle_test_seat_list sheed "B-driver" (ai_actors driver/banshee)) 5)
									(ai_migrate driver/banshee 4_cityshee)
									(object_teleport sheed 4_bflaga)
									(recording_play sheed 4_trollA2)
								)				
							)
							(if (> 0 (unit_get_health sheec))
								(begin
									(ai_place driver/banshee)
									(sleep 1)
									(object_create_anew sheec)
									(sleep 1)
									(vehicle_load_magic sheec "B-driver" (ai_actors driver/banshee))
									(sleep_until (vehicle_test_seat_list sheec "B-driver" (ai_actors driver/banshee)) 5)
									(ai_migrate driver/banshee 4_cityshee)
									(object_teleport sheec 2_bflagd)
									(recording_play sheec 2_chronoB1)
									(object_teleport sheec 4_bflaga)
									(recording_play sheec 4_trollA2)
									
								)				
							)
						)
				)
				(if (or  (volume_test_objects 4C (players)) (volume_test_objects 4B (players)))
						(begin
							(if (> 0 (unit_get_health sheed))
								(begin
									(ai_place driver/banshee)
									(sleep 1)
									(object_create_anew sheed)
									(sleep 1)
									(vehicle_load_magic sheed "B-driver" (ai_actors driver/banshee))
									(sleep_until (vehicle_test_seat_list sheed "B-driver" (ai_actors driver/banshee)) 5)
									(ai_migrate driver/banshee 4_cityshee)
									(object_teleport sheed 4_bflagB)
									(recording_play sheed 2_newmombasaA1)
									(sleep_until (> 1350 (recording_time sheed)) 5)
									(recording_kill sheed)
								)				
							)
							(if (> 0 (unit_get_health sheec))
								(begin
									(ai_place driver/banshee)
									(sleep 1)
									(object_create_anew sheec)
									(sleep 1)
									(vehicle_load_magic sheec "B-driver" (ai_actors driver/banshee))
									(sleep_until (vehicle_test_seat_list sheec "B-driver" (ai_actors driver/banshee)) 5)
									(ai_migrate driver/banshee 4_cityshee)
									(object_teleport sheec 4_bflagB)
									(recording_play sheec 2_newmombasaA1)
									(sleep_until (> 1350 (recording_time sheec)) 5)
									(recording_kill sheec)
								)				
							)
						)
						
					)
				)
		)
		
(sleep 1800)
)






;;;;END OF MARINE/VEHICLE SCRIPTS
;;;;END OF MARINE/VEHICLE SCRIPTS




;;;;END OF MARINE/VEHICLE SCRIPTS
;;;;END OF MARINE/VEHICLE SCRIPTS
;;;;END OF MARINE/VEHICLE SCRIPTS
;;;;END OF MARINE/VEHICLE SCRIPTS






;;This script is to help guarantee engagements between A.I. across the map. The BSP sections are large and open, this isn't a small skirmish
;; but rather an invasion of a planet. There will be large battles constantly that the A.I. must know about and actively participate in. For this reason
;; all A.I. are aware of all other A.I. at all times, using magically_see_encounter.


(script continuous bloodlust

	(if (= 0 (structure_bsp_index))
	
		(begin
		
			(ai_magically_see_encounter 0_jalley 0_cybase)
			(ai_magically_see_encounter 0_jalley 0_oldtown)
			(ai_magically_see_encounter 0_jalley 0_underpass)
			(ai_magically_see_encounter 0_cybase 0_jalley)
			(ai_magically_see_encounter 0_oldtown 0_jalley)
			(ai_magically_see_encounter 0_underpass 0_jalley)
			
			
			(ai_magically_see_encounter 0_turf 0_cybase)
			(ai_magically_see_encounter 0_turf 0_oldtown)
			(ai_magically_see_encounter 0_turf 0_underpass)
			(ai_magically_see_encounter 0_cybase 0_turf)
			(ai_magically_see_encounter 0_oldtown 0_turf)
			(ai_magically_see_encounter 0_underpass 0_turf)
			
			(ai_magically_see_encounter 0_courtyard 0_cybase)
			(ai_magically_see_encounter 0_courtyard 0_oldtown)
			(ai_magically_see_encounter 0_courtyard 0_underpass)
			(ai_magically_see_encounter 0_cybase 0_courtyard)
			(ai_magically_see_encounter 0_oldtown 0_courtyard)
			(ai_magically_see_encounter 0_underpass 0_courtyard)
			
			
		
		)
	
	
	)
	
	
	(if (= 1 (structure_bsp_index))
	
		(begin
		
			(ai_magically_see_encounter 1_ivory 1_base)
			(ai_magically_see_encounter 1_ivory 1_station)
			(ai_magically_see_encounter 1_ivory 1_tower)
			(ai_magically_see_encounter 1_base 1_ivory)
			(ai_magically_see_encounter 1_station 1_ivory)
			(ai_magically_see_encounter 1_tower 1_ivory)
			
			
			(ai_magically_see_encounter 1_headlong 1_base)
			(ai_magically_see_encounter 1_headlong 1_station)
			(ai_magically_see_encounter 1_headlong 1_tower)
			(ai_magically_see_encounter 1_base 1_headlong)
			(ai_magically_see_encounter 1_station 1_headlong)
			(ai_magically_see_encounter 1_tower 1_headlong)
			
			(ai_magically_see_encounter 1_terminal 1_base)
			(ai_magically_see_encounter 1_terminal 1_station)
			(ai_magically_see_encounter 1_terminal 1_tower)
			(ai_magically_see_encounter 1_base 1_terminal)
			(ai_magically_see_encounter 1_station 1_terminal)
			(ai_magically_see_encounter 1_tower 1_terminal)
			
			(ai_magically_see_encounter 1_parking 1_base)
			(ai_magically_see_encounter 1_parking 1_station)
			(ai_magically_see_encounter 1_parking 1_tower)
			(ai_magically_see_encounter 1_base 1_parking)
			(ai_magically_see_encounter 1_station 1_parking)
			(ai_magically_see_encounter 1_tower 1_parking)
			
			(ai_magically_see_encounter 1_interior 1_base)
			(ai_magically_see_encounter 1_interior 1_station)
			(ai_magically_see_encounter 1_interior 1_tower)
			(ai_magically_see_encounter 1_base 1_interior)
			(ai_magically_see_encounter 1_station 1_interior)
			(ai_magically_see_encounter 1_tower 1_interior)
			
			
		
		)
	
	
	)
	
	(if (= 2 (structure_bsp_index))
	
		(begin
		
			(ai_magically_see_encounter 2_newmombasa 2_base)
			(ai_magically_see_encounter 2_newmombasa 2_mombasamarine)
			(ai_magically_see_encounter 2_newmombasa 2_chronomarine)
			(ai_magically_see_encounter 2_base 2_newmombasa)
			(ai_magically_see_encounter 2_mombasamarine 2_newmombasa)
			(ai_magically_see_encounter 2_chronomarine 2_newmombasa)
		
			(ai_magically_see_encounter 2_chronoghosts 2_base)
			(ai_magically_see_encounter 2_chronoghosts 2_mombasamarine)
			(ai_magically_see_encounter 2_chronoghosts 2_chronomarine)
			(ai_magically_see_encounter 2_base 2_chronoghosts)
			(ai_magically_see_encounter 2_mombasamarine 2_chronoghosts)
			(ai_magically_see_encounter 2_chronomarine 2_chronoghosts)
		
			(ai_magically_see_encounter 2_mombasaghosts 2_base)
			(ai_magically_see_encounter 2_mombasaghosts 2_mombasamarine)
			(ai_magically_see_encounter 2_mombasaghosts 2_chronomarine)
			(ai_magically_see_encounter 2_base 2_mombasaghosts)
			(ai_magically_see_encounter 2_mombasamarine 2_mombasaghosts)
			(ai_magically_see_encounter 2_chronomarine 2_mombasaghosts)			
			
			(ai_magically_see_encounter 2_mombasarear 2_base)
			(ai_magically_see_encounter 2_mombasarear 2_mombasamarine)
			(ai_magically_see_encounter 2_mombasarear 2_chronomarine)
			(ai_magically_see_encounter 2_base 2_mombasarear)
			(ai_magically_see_encounter 2_mombasamarine 2_mombasarear)
			(ai_magically_see_encounter 2_chronomarine 2_mombasarear)
			
			(ai_magically_see_encounter 2_loadingbay 2_base)
			(ai_magically_see_encounter 2_loadingbay 2_mombasamarine)
			(ai_magically_see_encounter 2_loadingbay 2_chronomarine)
			(ai_magically_see_encounter 2_base 2_loadingbay)
			(ai_magically_see_encounter 2_mombasamarine 2_loadingbay)
			(ai_magically_see_encounter 2_chronomarine 2_loadingbay)
			
			
			(ai_magically_see_encounter 2_chronoparking 2_base)
			(ai_magically_see_encounter 2_chronoparking 2_mombasamarine)
			(ai_magically_see_encounter 2_chronoparking 2_chronomarine)
			(ai_magically_see_encounter 2_base 2_chronoparking)
			(ai_magically_see_encounter 2_mombasamarine 2_chronoparking)
			(ai_magically_see_encounter 2_chronomarine 2_chronoparking)
			
			(ai_magically_see_encounter 2_chronorear 2_base)
			(ai_magically_see_encounter 2_chronorear 2_mombasamarine)
			(ai_magically_see_encounter 2_chronorear 2_chronomarine)
			(ai_magically_see_encounter 2_base 2_chronorear)
			(ai_magically_see_encounter 2_mombasamarine 2_chronorear)
			(ai_magically_see_encounter 2_chronomarine 2_chronorear)
			
			
			
			(ai_magically_see_encounter 2_mombasamarine 2_mombasaghosts)
			(ai_magically_see_encounter 2_mombasaghosts 2_mombasamarine)
		
			
			
		
		)
	
	
	)
	
	
	(if (= 3 (structure_bsp_index))
	
		(begin
		
			(ai_magically_see_encounter 3_front 3_marinefront)
			(ai_magically_see_encounter 3_front 3_marinemid)
			(ai_magically_see_encounter 3_front 3_marineback)
			(ai_magically_see_encounter 3_front 3_warthog)
			
			(ai_magically_see_encounter 3_mid 3_marinefront)
			(ai_magically_see_encounter 3_mid 3_marinemid)
			(ai_magically_see_encounter 3_mid 3_marineback)
			(ai_magically_see_encounter 3_mid 3_warthog)
			
			(ai_magically_see_encounter 3_back 3_marinefront)
			(ai_magically_see_encounter 3_back 3_marinemid)
			(ai_magically_see_encounter 3_back 3_marineback)
			(ai_magically_see_encounter 3_back 3_warthog)
		
			(ai_magically_see_encounter 3_marinefront 3_front)
			(ai_magically_see_encounter 3_marinefront 3_mid)
			(ai_magically_see_encounter 3_marinefront 3_back)
			(ai_magically_see_encounter 3_marinefront 3_ghost)
			
			(ai_magically_see_encounter 3_marinemid 3_front)
			(ai_magically_see_encounter 3_marinemid 3_mid)
			(ai_magically_see_encounter 3_marinemid 3_back)
			(ai_magically_see_encounter 3_marinemid 3_ghost)
			
			(ai_magically_see_encounter 3_marineback 3_front)
			(ai_magically_see_encounter 3_marineback 3_mid)
			(ai_magically_see_encounter 3_marineback 3_back)
			(ai_magically_see_encounter 3_marineback 3_ghost)
			
			(ai_magically_see_encounter 3_ghost 3_warthog)
			(ai_magically_see_encounter 3_warthog 3_ghost)
			
			
		
		)
	
	
	)
	
	(if (= 4 (structure_bsp_index))
	
		(begin
		
			(ai_magically_see_encounter 4_front 4_marinea)
			(ai_magically_see_encounter 4_front 4_marineb)
			(ai_magically_see_encounter 4_front 4_marinec)
			(ai_magically_see_encounter 4_front 4_bridgehog)
			
			(ai_magically_see_encounter 4_mid 4_marinea)
			(ai_magically_see_encounter 4_mid 4_marineb)
			(ai_magically_see_encounter 4_mid 4_marinec)
			(ai_magically_see_encounter 4_mid 4_bridgehog)
			
			(ai_magically_see_encounter 4_back 4_marinea)
			(ai_magically_see_encounter 4_back 4_marineb)
			(ai_magically_see_encounter 4_back 4_marinec)
			(ai_magically_see_encounter 4_back 4_bridgehog)
		
			(ai_magically_see_encounter 4_marinea 4_front)
			(ai_magically_see_encounter 4_marinea 4_mid)
			(ai_magically_see_encounter 4_marinea 4_back)
			(ai_magically_see_encounter 4_marinea 4_bridgeghost)
			
			(ai_magically_see_encounter 4_marineb 4_front)
			(ai_magically_see_encounter 4_marineb 4_mid)
			(ai_magically_see_encounter 4_marineb 4_back)
			(ai_magically_see_encounter 4_marineb 4_bridgeghost)
			
			(ai_magically_see_encounter 4_marinec 4_front)
			(ai_magically_see_encounter 4_marinec 4_mid)
			(ai_magically_see_encounter 4_marinec 4_back)
			(ai_magically_see_encounter 4_marinec 4_bridgeghost)
			
			(ai_magically_see_encounter 4_bridgeghost 4_bridgehog)
			(ai_magically_see_encounter 4_bridgehog 4_bridgeghost)
			
			(ai_magically_see_encounter 4_a 4_marinea)
			(ai_magically_see_encounter 4_a 4_marineb)
			(ai_magically_see_encounter 4_a 4_marinec)
			(ai_magically_see_encounter 4_a 4_bridgehog)

			(ai_magically_see_encounter 4_b 4_marinea)
			(ai_magically_see_encounter 4_b 4_marineb)
			(ai_magically_see_encounter 4_b 4_marinec)
			(ai_magically_see_encounter 4_b 4_bridgehog)

			(ai_magically_see_encounter 4_c 4_marinea)
			(ai_magically_see_encounter 4_c 4_marineb)
			(ai_magically_see_encounter 4_c 4_marinec)
			(ai_magically_see_encounter 4_c 4_bridgehog)
			
			
		
		)
		
	)
	
	(if (= 5 (structure_bsp_index))
	
		(begin
		
			(ai_magically_see_encounter 5_a 5_marineA)
			(ai_magically_see_encounter 5_a 5_marineb)
			
			(ai_magically_see_encounter 5_b 5_marineA)
			(ai_magically_see_encounter 5_b 5_marineb)
			
			
			(ai_magically_see_encounter 5_c 5_marineA)
			(ai_magically_see_encounter 5_c 5_marineb)
			
			
		
			(ai_magically_see_encounter 5_marineA 5_a)
			(ai_magically_see_encounter 5_marineA 5_b)
			(ai_magically_see_encounter 5_marineA 5_c)
			
			
			(ai_magically_see_encounter 5_marineb 5_a)
			(ai_magically_see_encounter 5_marineb 5_b)
			(ai_magically_see_encounter 5_marineb 5_c)
			
			
			(ai_magically_see_encounter 4_marinec 5_a)
			(ai_magically_see_encounter 4_marinec 5_b)
			(ai_magically_see_encounter 4_marinec 5_c)
			
			
			
			
		
		)
		
	)
	
	
	


(sleep 30)

)






	
	
;; The following script allows for the marines to "follow" the player around the map. Based on the location that the player is in, the marines will migrate to that encounter and use those firing points. It also forces the Covenant to move towards the encounter the player is in but only after they've been placed in the map. On the two largest BSPs, we actively kill AI that the player cannot see or interact with.

(script continuous 0migration
	
	(cond
		((volume_test_objects 0overpass (players))
			(begin
				(ai_migrate 0_cybase 0_oldtown)
				(ai_migrate 0_underpass 0_oldtown)
				
				
				(ai_migrate 0_courtyard/c 0_jalley/c)
				(ai_migrate 0_turf/c 0_jalley/c)
				
			)
		)
		((volume_test_objects 0base (players))
			(begin
				(ai_migrate 0_underpass 0_cybase)
				(ai_migrate 0_oldtown 0_cybase)
				
				(ai_migrate 0_jalley/c 0_courtyard/c)
				(ai_migrate 0_turf/c 0_courtyard/c)
				
			))
		((volume_test_objects 0court (players))
			(begin
				(ai_migrate 0_underpass 0_cybase)
				(ai_migrate 0_oldtown 0_cybase)
				
				(ai_migrate 0_jalley/c 0_courtyard/c)
				(ai_migrate 0_turf/c 0_courtyard/c)
			))
		((volume_test_objects 0alley (players))
			(begin
				(ai_migrate 0_cybase 0_oldtown)
				(ai_migrate 0_underpass 0_oldtown)
				
				(ai_migrate 0_courtyard/c 0_jalley/c)
				(ai_migrate 0_turf/c 0_jalley/c)
			))
		((volume_test_objects 0town (players))
			(begin
				(ai_migrate 0_cybase 0_underpass)
				(ai_migrate 0_oldtown 0_underpass)
				
				(ai_migrate 0_courtyard/c 0_jalley/c)
				
			))
		((volume_test_objects 0turf (players))
			(begin
				(ai_migrate 0_cybase 0_underpass)
				(ai_migrate 0_oldtown 0_underpass)
				
				(ai_migrate 0_courtyard/c 0_turf/c)
				(ai_migrate 0_jalley/c 0_turf/c)
			))
		((volume_test_objects 0exit (players))
			(begin
				(ai_migrate 0_underpass 0_cybase)
				(ai_migrate 0_oldtown 0_cybase)
				
				(ai_migrate 0_jalley/c 0_courtyard/c)
				(ai_migrate 0_turf/c 0_courtyard/c)
			))
	)
)


(script continuous 1migration
	
	(cond
		((volume_test_objects 1parkinglot (players))
			(begin
				(ai_migrate 1_base 1_station)				
			)
		)
		((volume_test_objects 1station (players))
			(begin
				(ai_migrate 1_base 1_station)	

				(ai_migrate 1_headlong/c 1_terminal/c)
				(ai_migrate 1_ivory 1_terminal/c)
				
			)
		)
		((volume_test_objects 1terminal (players))
			(begin
				(ai_migrate 1_base 1_station)				
			)
		)
		
		((volume_test_objects 1headlong (players))
			(begin
				(ai_migrate 1_station 1_base)

				(ai_migrate 1_ivory 1_headlong/c)
				(ai_migrate 1_terminal/c 1_headlong/c)
			)
		)
		((volume_test_objects 1interiors (players))
			(begin
				(ai_migrate 1_station 1_base)				
			)
		)
		((volume_test_objects 1ivory (players))
			(begin
			(ai_kill 1_interiors)
				(if (< 20 (+ (ai_living_count 1_headlong)(ai_living_count 1_terminal)))
					(begin
						(ai_kill 1_headlong)
						(ai_kill 1_terminal)
					)
				)
			)
		)
		
	)
)

(script continuous 2migration
	
	(cond
		
		((or (volume_test_objects 2mombafront (players)) (volume_test_objects 2mombaback (players)) )
			(begin
				(ai_kill 2_chronoparking)
				(ai_kill 2_chronorear)
			)
		)
		((volume_test_objects 2chronopolis (players))
			(begin
				(ai_kill 2_mombasarear)
				(ai_kill 2_newmombasa)
			)
		)
		
		
	)
)



;;;  BSP 2 does not have marines outside of the ones in warthogs.
;;;	 So there are no marines to migrate.


(script continuous 3migration
	
	(cond
		
		((volume_test_objects 3front (players))
			(begin
				(ai_migrate 3_marinemid/m 3_marinefront/m)				
				(ai_migrate 3_marineback/m 3_marinefront/m)	

				(ai_migrate 3_mid/c 3_front/c)
				(ai_migrate 3_back/c 3_front/c)
			)
		)
		((volume_test_objects 3mid (players))
			(begin
				(ai_migrate 3_marinefront/m 3_marinemid/m)				
				(ai_migrate 3_marineback/m 3_marinemid/m)

				(ai_migrate 3_front/c 3_mid/c)
				(ai_migrate 3_back/c 3_mid/c)				
			)
		)
		((volume_test_objects 3back (players))
			(begin
				(ai_migrate 3_marinemid/m 3_marineback/m)				
				(ai_migrate 3_marinefront/m 3_marineback/m)	

				(ai_migrate 3_mid/c 3_back/c)
				(ai_migrate 3_mid/c 3_back/c)
			)
		)
		
	)
)

(script continuous 4migration
	
	(cond
		
		((volume_test_objects 4a (players))
			(begin
				(ai_migrate 4_marineb/m 4_marinea/m)				
				(ai_migrate 4_marinec/m 4_marinea/m)	
				
				(ai_migrate 4_back/c 4_a/c)
				(ai_migrate 4_b/c 4_a/c)
				(ai_kill 4_c)
				(ai_kill 4_front)
				(ai_kill 4_mid)
				

				
			)
		)
		((volume_test_objects 4b (players))
			(begin
				(ai_migrate 4_marinea/m 4_marineb/m)				
				(ai_migrate 4_marinec/m 4_marineb/m)	

				(ai_migrate 4_a/c 4_b/c)
				(ai_migrate 4_c/c 4_b/c)	
				
				(ai_kill 4_back)
				(ai_kill 4_mid)
				(ai_kill 4_front)
			)
		)
		((volume_test_objects 4c (players))
			(begin
				(ai_migrate 4_marineb/m 4_marinec/m)				
				(ai_migrate 4_marinea/m 4_marinec/m)	
				
				
				(ai_migrate 4_b/c 4_c/c)
				(ai_kill 4_a)
				(ai_kill 4_back)
				(ai_kill 4_mid)
				(ai_kill 4_front)
			)
		)
		((volume_test_objects 4front (players))
			(begin
					
				
				
				(ai_migrate 4_mid/c 4_front/c)
				
				
				(ai_kill 4_back)
				(ai_kill 4_mid)
				(ai_kill 4_a)
				(ai_kill 4_b)
				(ai_kill 4_c)
			)
		)
		((volume_test_objects 4mid (players))
			(begin
				
				
				
				(ai_migrate 4_front/c 4_mid/c)
				(ai_migrate 4_back/c 4_mid/c)
				
				(ai_kill 4_a)
				(ai_kill 4_b)
				(ai_kill 4_c)
				
			)
		)
		((volume_test_objects 4back (players))
			(begin
					
				
				
				(ai_migrate 4_a/c 4_back/c)
				(ai_migrate 4_mid/c 4_back/c)
				
				(ai_kill 4_front)
				(ai_kill 4_b)
				(ai_kill 4_c)
			)
		)
		
	)
)

(script continuous 5migration
	
	(cond
		
		((volume_test_objects 5a (players))
			(begin
				(ai_migrate 5_marineb/m 5_marinea/m)

				(ai_migrate 5_b/c 5_a/c)
				(ai_migrate 5_c/c 5_a/c)
								
			)
		)
		((or (volume_test_objects 5b (players)) (volume_test_objects 5c (players)))
			(begin
				(ai_migrate 5_marinea/m 5_marineb/m)				
				
				(ai_migrate 5_a/c 5_b/c)
								
			)
		)
		
	)
)


(script continuous 0snipers

	(cond
			(
				(volume_test_objects 0base (players))
					(begin
						(ai_kill_silent 0_snipers/jalley)
						(ai_kill_silent 0_snipers/overpass)
					
						(if (> 2 (ai_living_count 0_snipers))
						(ai_place 0_snipers/town)
						)
						
					
					)
			)
			
			(
				(volume_test_objects 0court (players))
					(begin
						(ai_kill_silent 0_snipers/jalley)
						(ai_kill_silent 0_snipers/town)
					
						(if (> 2 (ai_living_count 0_snipers))
						(ai_place 0_snipers/courtyard)
						)
					
					)
			)
			
			(
				(volume_test_objects 0alley (players))
					(begin
						(ai_kill_silent 0_snipers/courtyard)
											
						(if (> 2 (ai_living_count 0_snipers))
						(ai_place 0_snipers/jalley)
						)
					
					)
			)
			
			(
				(volume_test_objects 0overpass (players))
					(begin
						(ai_kill_silent 0_snipers/courtyard)
											
						(if (> 2 (ai_living_count 0_snipers))
						(ai_place 0_snipers/jalley)
						)
					
					)
			)
			
			(
				(volume_test_objects 0town (players))
					(begin
						(ai_kill_silent 0_snipers/courtyard)
						(ai_kill_silent 0_snipers/overpass)
											
						(if (> 2 (ai_living_count 0_snipers))
						(ai_place 0_snipers/town)
						)
					
					)
			)
			
			
			
			(
				(volume_test_objects 0turf (players))
					(begin
						(ai_kill_silent 0_snipers/courtyard)
						(ai_kill_silent 0_snipers/overpass)
											
						(if (> 2 (ai_living_count 0_snipers))
						(ai_place 0_snipers/town)
						)
					
					)
			)
			
		
			(
				(volume_test_objects 0exit (players))
					(begin
						(ai_kill_silent 0_snipers/town)
						(ai_kill_silent 0_snipers/overpass)
						(ai_kill_silent 0_snipers/jalley)
											
						(if (> 2 (ai_living_count 0_snipers))
						(ai_place 0_snipers/town)
						)
					
					)
			)

	)
		
	(if (> 2 (ai_living_count 0_snipers))
		(sleep 10)
		(sleep (* 30 60))
	)
)


(script continuous 1snipers

	(cond
			(
				(volume_test_objects 1parkinglot (players))
					(begin
						(ai_kill_silent 1_snipers/headlong)
						(ai_kill_silent 1_snipers/park)
					
						(if (> 2 (ai_living_count 1_snipers))
						(ai_place 1_snipers/train)
						)
						
					
					)
			)
			
			(
				(volume_test_objects 1station (players))
					(begin
						(ai_kill_silent 1_snipers/headlong)
						(ai_kill_silent 1_snipers/park)
					
						(if (> 2 (ai_living_count 1_snipers))
						(ai_place 1_snipers/train)
						)						
					
					)
			)
			
			(
				(volume_test_objects 1terminal (players))
					(begin
						(ai_kill_silent 1_snipers/headlong)
						
					
						(if (> 2 (ai_living_count 1_snipers))
						(ai_place 1_snipers/train)
						)
						
					
					)
			)
			
			(
				(volume_test_objects 1park (players))
					(begin
						(if (> 2 (ai_living_count 1_snipers))
						(ai_place 1_snipers/park)
						)
						
					
					)
			)
			
			(
				(volume_test_objects 1headlong (players))
					(begin
						(ai_kill_silent 1_snipers/train)
						
					
						(if (> 2 (ai_living_count 1_snipers))
						(ai_place 1_snipers/headlong)
						)
						
					
					)
			)
			
			
			
			(
				(volume_test_objects 1interiors (players))
					(begin
						(ai_kill_silent 1_snipers/train)
						(ai_kill_silent 1_snipers/park)
						
					
						(if (> 2 (ai_living_count 1_snipers))
						(ai_place 1_snipers/headlong)
						)
						
					
					)
			)
			
		
			(
				(volume_test_objects 1ivory (players))
					(begin
						(ai_kill_silent 1_snipers/train)
						(ai_kill_silent 1_snipers/headlong)
						
					
						(if (> 2 (ai_living_count 1_snipers))
						(ai_place 1_snipers/park)
						)
						
					
					)
			)

	)
		
	(if (> 2 (ai_living_count 1_snipers))
		(sleep 10)
		(sleep (* 30 60))
	)
)


(script continuous 2snipers

	(cond
					
		
			(
				(or (volume_test_objects 2mombafront (players)) (volume_test_objects 2mombaback (players)))
					(begin
						(ai_kill_silent 2_snipers/chronopolis)
												
					
						(if (> 2 (ai_living_count 2_snipers))
						(ai_place 2_snipers/mombasa)
						)
						
					
					)
			)
			
			
			(
				(volume_test_objects 2chronopolis (players))
					(begin
						(ai_kill_silent 2_snipers/mombasa)
												
					
						(if (> 2 (ai_living_count 2_snipers))
						(ai_place 2_snipers/chronopolis)
						)
						
					
					)
			)

	)
		
	(if (> 2 (ai_living_count 2_snipers))
		(sleep 10)
		(sleep (* 30 60))
	)
)

(script continuous 3snipers

	(cond
					
		
			(
				(volume_test_objects 3front (players)) 
					(begin
						(ai_kill_silent 3_snipers/back)
												
					
						(if (> 2 (ai_living_count 3_snipers))
						(ai_place 3_snipers/front)
						)
						
					
					)
			)
			
			
			(
				(volume_test_objects 3mid (players))
					(begin
						
												
					
						(if (> 2 (ai_living_count 3_snipers))
						(ai_place 3_snipers/mid)
						)
						
					
					)
			)
			
			(
				(volume_test_objects 3back (players))
					(begin
						(ai_kill_silent 3_snipers/front)
												
					
						(if (> 2 (ai_living_count 3_snipers))
						(ai_place 3_snipers/back)
						)
						
					
					)
			)

	)
		
	(if (> 2 (ai_living_count 3_snipers))
		(sleep 10)
		(sleep (* 30 60))
	)
)


(script continuous 4snipers

	(cond
					
		
			(
				(or (volume_test_objects 4front (players)) (volume_test_objects 4front (players)))
					(begin
						(ai_kill_silent 4_snipers/back)
						(ai_kill_silent 4_snipers/A)
						(ai_kill_silent 4_snipers/B)
						(ai_kill_silent 4_snipers/C)
												
					
						(if (> 3 (ai_living_count 4_snipers))
						(ai_place 4_snipers/front)
						)
						
					
					)
			)
			
			
			
			
			(
				(volume_test_objects 4back (players))
					(begin
						(ai_kill_silent 4_snipers/front)
						(ai_kill_silent 4_snipers/B)
						(ai_kill_silent 4_snipers/C)
												
					
						(if (> 3 (ai_living_count 4_snipers))
						(ai_place 4_snipers/back)
						)
						
					
					)
			)
			
			(
				(volume_test_objects 4A (players))
					(begin
						(ai_kill_silent 4_snipers/C)
						(ai_kill_silent 4_snipers/front)
						
												
					
						(if (> 3 (ai_living_count 4_snipers))
						(ai_place 4_snipers/A)
						)
						
					
					)
			)
			
			(
				(volume_test_objects 4B (players))
					(begin
						
						(ai_kill_silent 4_snipers/front)
						(ai_kill_silent 4_snipers/back)
												
					
						(if (> 3 (ai_living_count 4_snipers))
						(ai_place 4_snipers/B)
						)
						
					
					)
			)
			
			(
				(volume_test_objects 4C (players))
					(begin
						(ai_kill_silent 4_snipers/A)
						(ai_kill_silent 4_snipers/front)
						(ai_kill_silent 4_snipers/back)
												
					
						(if (> 3 (ai_living_count 4_snipers))
						(ai_place 4_snipers/C)
						)
						
					
					)
			)

	)
		
	(if (> 2 (ai_living_count 4_snipers))
		(sleep 10)
		(sleep (* 30 60))
	)
)


(script continuous 5snipers

	(cond
			
			(
				(volume_test_objects 5A (players))
					(begin
						
												
					
						(if (> 3 (ai_living_count 5_snipers))
						(ai_place 5_snipers/tombstone)
						)
						
					
					)
			)	
			
			
			(
				(or (volume_test_objects 5A (players)) (volume_test_objects 5B (players)))
					(begin
						
												
					
						(if (> 3 (ai_living_count 5_snipers))
						(ai_place 5_snipers/zanzibar)
						)
						
					
					)
			)
			
				
	)
		
	(if (> 2 (ai_living_count 5_snipers))
		(sleep 10)
		(sleep (* 30 60))
	)
)






