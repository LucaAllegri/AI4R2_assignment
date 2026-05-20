(define (problem PDDL_PLUS_Q2) 

    (:domain PDDL_plus_Warehouse_Conveyor)
    (:objects 
        r1 r2 r3 r4 r5 r6 r7 - robot

        storage1 l1 l2 l3 storage2
        l4 l5 l6 l7 l8 l9 l10
        l11 l12 l13 l14 l15 l16 l17
        l18 l19 l20 l21 l22 l23 l24
        l25 l26 l27 l28 l29 l30 l31 - location

        delivery1 delivery2 delivery3 delivery4 delivery5 delivery6 - location
        delivery7 delivery8 delivery9 delivery10 delivery11 delivery12 - location

        cMain cRight cLeft cBackR cBackL - conveyor

        p1 p2 - package 
    )

    (:init

        ;; BELT SEGMENTS OF THE CONVEYORS
        (belt-segment cMain storage1 l1)
        (belt-segment cMain l1 l2)
        (belt-segment cMain l2 l3)
        (belt-segment cMain l3 storage2)

        (belt-segment cRight l4 l5)
        (belt-segment cRight l5 l6)
        (belt-segment cRight l6 l7)
        (belt-segment cRight l7 l8)
        (belt-segment cRight l8 l9)
        (belt-segment cRight l9 l10)

        (belt-segment cLeft l18 l19)
        (belt-segment cLeft l19 l20)
        (belt-segment cLeft l20 l21)
        (belt-segment cLeft l21 l22)
        (belt-segment cLeft l22 l23)
        (belt-segment cLeft l23 l24)

        (belt-segment cBackR l11 l12)
        (belt-segment cBackR l12 l13)
        (belt-segment cBackR l13 l14)
        (belt-segment cBackR l14 l15)
        (belt-segment cBackR l15 l16)
        (belt-segment cBackR l16 l17)
        (belt-segment cBackR l17 storage1)

        (belt-segment cBackL l25 l26)
        (belt-segment cBackL l26 l27)
        (belt-segment cBackL l27 l28)
        (belt-segment cBackL l28 l29)
        (belt-segment cBackL l29 l30)
        (belt-segment cBackL l30 l31)
        (belt-segment cBackL l31 storage1)
        ;;---------------------------------

        ;; CONVEYOR ENTRIES
        (conveyor-entry cMain storage1)
        (conveyor-entry cRight l4)
        (conveyor-entry cLeft l18)
        (conveyor-entry cBackR l11)
        (conveyor-entry cBackL l25)
        ;;---------------------------------

        ;; CONVEYOR EXITS
        (conveyor-exit cMain storage2)
        (conveyor-exit cRight l10)
        (conveyor-exit cLeft l24)
        (conveyor-exit cBackR l17)
        (conveyor-exit cBackL l31)
        ;;---------------------------------

        ;;CONVEYOR CONNECTED
        (conveyor-connected cRight cBackR l10 l11)
        (conveyor-connected cLeft cBackL l24 l25)
        (conveyor-connected cBackR cMain l17 storage1)
        (conveyor-connected cBackL cMain l31 storage1)
        ;;---------------------------------

        ;; UNLOADING ZONES
        (unload-zone storage1)
        (unload-zone storage2)
        (unload-zone l6)
        (unload-zone l8)
        (unload-zone l10)
        (unload-zone l20) 
        (unload-zone l22)
        (unload-zone l24)
        ;;---------------------------------

        ;; PICKING ZONES
        (load-zone storage1)
        (load-zone l4)
        (load-zone l18)
        ;;---------------------------------

        ;; DELIVERY ZONES
        (delivery-zone delivery1)
        (delivery-zone delivery2)
        (delivery-zone delivery3)
        (delivery-zone delivery4)
        (delivery-zone delivery5)
        (delivery-zone delivery6)
        (delivery-zone delivery7)
        (delivery-zone delivery8)
        (delivery-zone delivery9)
        (delivery-zone delivery10)
        (delivery-zone delivery11)
        (delivery-zone delivery12)
        ;;---------------------------------

        ;; ROBOT ACTION ZONES
        (robot-act-on r1 storage2)
        (robot-act-on r1 l4)
        (robot-act-on r1 l18)
        (robot-act-on r2 l6)
        (robot-act-on r2 delivery1)
        (robot-act-on r2 delivery2)
        (robot-act-on r3 l8)
        (robot-act-on r3 delivery3)
        (robot-act-on r3 delivery4)
        (robot-act-on r4 l10)
        (robot-act-on r4 delivery5)
        (robot-act-on r4 delivery6)
        (robot-act-on r5 l20)
        (robot-act-on r5 delivery7)
        (robot-act-on r5 delivery8)
        (robot-act-on r6 l22)
        (robot-act-on r6 delivery9)
        (robot-act-on r6 delivery10)
        (robot-act-on r7 l24)
        (robot-act-on r7 delivery11)
        (robot-act-on r7 delivery12)
        ;;---------------------------------

        ;; INITIAL ROBOT POSITIONS
        (robot-at r1 storage2)
        (robot-at r2 l6)
        (robot-at r3 l8)
        (robot-at r4 l10)
        (robot-at r5 l20)
        (robot-at r6 l22)
        (robot-at r7 l24)

        (handempty r1)
        (handempty r2)
        (handempty r3)
        (handempty r4)
        (handempty r5)
        (handempty r6)
        (handempty r7)
        ;;---------------------------------

        ;; INITIAL PACKAGE POSITIONS
        (package-at p1 l4)
        (on-belt p1 cRight)

        (package-at p2 l2)
        (on-belt p2 cMain)

        ;;---------------------------------

        ;; BELT FREE
        ;; cMain
        (belt-free storage1) 
        (belt-free l1) 
        ;(belt-free l2) 
        (belt-free l3) (belt-free storage2)

        ;; cRight
        ;(belt-free l4)  
        (belt-free l5)  
        (belt-free l6)  (belt-free l7)
        (belt-free l8)  (belt-free l9) (belt-free l10)

        ;; cLeft
        (belt-free l18) 
        (belt-free l19) 
        (belt-free l20) (belt-free l21)
        (belt-free l22) (belt-free l23) (belt-free l24)

        ;; cBackR
        (belt-free l11) (belt-free l12) (belt-free l13) (belt-free l14)
        (belt-free l15) (belt-free l16) (belt-free l17)

        ;; cBackL
        (belt-free l25) (belt-free l26) (belt-free l27) (belt-free l28)
        (belt-free l29) (belt-free l30) (belt-free l31)

        (belt-running cMain)
        (belt-running cRight)
        (belt-running cLeft)
        (belt-running cBackR)
        (belt-running cBackL)
        ;;---------------------------------

        ;; NUMERIC INITIALIZATION
        (= (total-cost) 0)

        ;; Progressi iniziali dei pacchi sul segmento attuale
        (= (belt-progress p1) 0.0)
        (= (belt-progress p2) 0.0)

        ;; Velocità dei singoli conveyor (indica quanto progresso fanno al secondo)
        (= (conveyor-speed cMain)  0.8)
        (= (conveyor-speed cRight) 0.8)
        (= (conveyor-speed cLeft)  0.8)
        (= (conveyor-speed cBackR) 0.8)
        (= (conveyor-speed cBackL) 0.8)

        ;; I timer di occupazione dei robot partono tutti a 0.0 (pronti ad agire)
        (= (busy-timer r1) 0.0)
        (= (busy-timer r2) 0.0)
        (= (busy-timer r3) 0.0)
        (= (busy-timer r4) 0.0)
        (= (busy-timer r5) 0.0)
        (= (busy-timer r6) 0.0)
        (= (busy-timer r7) 0.0)
        ;;---------------------------------

    )


    (:goal (and
        (package-at p1 delivery2)
        (package-at p2 delivery12)
    ))

    (:metric minimize (total-cost))

)
