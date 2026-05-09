(define (problem PDDL_Q1_OPTIONAL)

    (:domain PDDL_Warehouse_Conveyor)

    (:objects
        storage1 storage2 storage3 storage4 - location
        
        l1 l2 l3 l4 
        l5 l6 
        l7 l8 l9 l10 
        l11 l12 - location

        delivery1 delivery2 delivery3 delivery4 - location

        r1 - robot

        pck1 pck2 - package
    )

    (:init

        ;; first row of the grid
        (connected storage1 l1)
        (connected l1 storage1)
        (connected l1 l2)
        (connected l2 l1)
        (connected l2 l3)
        (connected l3 l2)
        (connected l3 l4)
        (connected l4 l3)
        (connected l4 delivery1)
        (connected delivery1 l4)

        ;; second row of the grid
        (connected storage2 l5)
        (connected l5 storage2)
        (connected l5 l2)
        (connected l2 l5)
        (connected l2 l6)
        (connected l6 l2)
        (connected l6 l4)
        (connected l4 l6)
        (connected l4 delivery2)
        (connected delivery2 l4)

        ;; third row of the grid
        (connected storage3 l7)
        (connected l7 storage3)
        (connected l7 l8)
        (connected l8 l7)
        (connected l8 l9)
        (connected l9 l8)
        (connected l9 l10)
        (connected l10 l9)
        (connected l10 delivery3)
        (connected delivery3 l10)

        ;; fourth row of the grid
        (connected storage4 l7)
        (connected l7 storage4)
        (connected l7 l11)
        (connected l11 l7)
        (connected l11 l12)
        (connected l12 l11)
        (connected l12 l10)
        (connected l10 l12)
        (connected l10 delivery4)
        (connected delivery4 l10)

        ;;first column of the grid
        (connected storage1 storage2)
        (connected storage2 storage1)
        (connected storage2 storage3)
        (connected storage3 storage2)
        (connected storage3 storage4)
        (connected storage4 storage3)

        ;;second column of the grid
        (connected l1 l5)
        (connected l5 l1)
        (connected l5 l7)
        (connected l7 l5)

        ;;third column of the grid
        (connected l2 l8)
        (connected l8 l2)

        ;;fourth column of the grid


        ;;fifth column of the grid
        (connected l4 l10)
        (connected l10 l4)

        ;;sixth column of the grid
        (connected delivery1 delivery2)
        (connected delivery2 delivery1)
        (connected delivery2 delivery3)
        (connected delivery3 delivery2)
        (connected delivery3 delivery4)
        (connected delivery4 delivery3)

        ;; TOP CONVEYOR BELT
        (belt-connected l2 l3)
        (belt-connected l2 l6)
        (belt-connected l3 l4)
        (belt-connected l6 l4)
        

        ;; BOTTOM CONVEYOR BELT
        (belt-connected l7 l8)
        (belt-connected l7 l11)
        (belt-connected l8 l9)
        (belt-connected l11 l12)
        (belt-connected l9 l10)
        (belt-connected l12 l10)

        ;;LOAD ZONES
        (load-zone l2)
        (load-zone l7)
        
        ;;UNLOAD ZONES
        (unload-zone storage1)
        (unload-zone storage2)
        (unload-zone storage3)
        (unload-zone storage4)
        (unload-zone l4)
        (unload-zone l10)

        ;;DELIVERY ZONES
        (delivery-zone delivery1)
        (delivery-zone delivery2)
        (delivery-zone delivery3)
        (delivery-zone delivery4)

        ;;ROBOT LOCATION
        (robot-at r1 l5)
        (handempty r1)

        ;;PACKAGE LOCATION
        (package-at pck1 storage1)
        (package-at pck2 storage3)

        (= (total-cost) 0)
    )

    (:goal
        (and
            (package-at pck1 delivery1)
            (package-at pck2 delivery4)
            (< (total-cost) 40)
        )
    )

    (:metric minimize (total-cost))

)