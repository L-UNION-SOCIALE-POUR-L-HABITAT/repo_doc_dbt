/**
 *
 * Description :    Alimentation de la table epci
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          int_epci
 * Cible :          epci 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_epci as
(
    select 
        epci_code,
        epci_libelle,
        epci_annee_last_flag
    
    from
        "wh_dp_silver"."dbo"."epci"

),

-- Application des filtres 
cte_filtered_ecpi as
(
    select 
        epci_code,
        epci_libelle

    from
        cte_epci
    where
        epci_annee_last_flag = 1
),

-- Ajout des clés techniques (différentes de la couche silver car sans année )
cte_hk_filtered_ecpi as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(epci_code as varchar(max))
    
)  
 
       as epci_hk
 

    from 
        cte_filtered_ecpi
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from
        cte_hk_filtered_ecpi
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale