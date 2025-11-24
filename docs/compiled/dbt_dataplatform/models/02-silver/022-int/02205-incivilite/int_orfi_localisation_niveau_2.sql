/**
 *
 * Description :    Alimentation de la table intermediate int_orfi_localisation_niveau_2
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          stg_orfi_localisation_niveau_2
 * Cible :          int_orfi_localisation_niveau_2
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_orfi_localisation_niveau_2 as 
(
    select 
        orfi_localisation_niveau_2_id,
        orfi_localisation_niveau_2_libelle,
        orfi_localisation_niveau_1_id
        
    from 
        "wh_dp_silver"."stg"."stg_orfi_localisation_niveau_2"
),





/*
cte_stg_reference as
(

),

cte_stg_orfi_group as 
(

)
*/

 
-------------------------------------------------------------------
--************************** FILTRAGE ****************************
-------------------------------------------------------------------

-- on souhaite recueperer que les organismes actifs
cte_filter_stg_orfi_localisation_niveau_2 as 
(
    select 
        *
        
    from 
        cte_stg_orfi_localisation_niveau_2

),



-------------------------------------------------------------------
--************* JOINTURE ET COLONNES CALCULEES ********************
-------------------------------------------------------------------
cte_calc_stg_orfi_localisation_niveau_2  as 
 (
    select
        *
    
    from cte_filter_stg_orfi_localisation_niveau_2
    --left join cte_stg_reference on ....
    --left join cte_stg_orfi_group on ....
 ),


-------------------------------------------------------------------
--********************** CLES TECHNIQUES *************************
-------------------------------------------------------------------
cte_hk_calc_stg_orfi_localisation_niveau_2 as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_localisation_niveau_2_id as varchar(max))
    
)  
 
         as orfi_localisation_niveau_2_hk
    from 
        cte_calc_stg_orfi_localisation_niveau_2
),
 
-------------------------------------------------------------------
--********************** ETAPE FINALE *************************
-------------------------------------------------------------------
 
 cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_stg_orfi_localisation_niveau_2
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale