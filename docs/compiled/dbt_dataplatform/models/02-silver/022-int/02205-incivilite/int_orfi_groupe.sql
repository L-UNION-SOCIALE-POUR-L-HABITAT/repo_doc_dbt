/**
 *
 * Description :    Alimentation de la table intermediate int_orfi_groupe
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          stg_orfi_groupe
 * Cible :          int_orfi_groupe
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_orfi_groupe as 
(
    select 
        orfi_groupe_id,
        organisme_code_union,
        organisme_groupe_libelle,
        organisme_commentaire_flag,
        organisme_agence_libelle,
        organisme_secteur_libelle,
        organisme_patrimoine_libelle,
        organisme_affichage_ancien_flag,
        organisme_pj_active_flag

    from 
        "wh_dp_silver"."stg"."stg_orfi_groupe"
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
cte_filter_stg_orfi_groupe as 
(
    select 
        *
        
    from 
        cte_stg_orfi_groupe

),



-------------------------------------------------------------------
--************* JOINTURE ET COLONNES CALCULEES ********************
-------------------------------------------------------------------
cte_calc_stg_orfi_groupe  as 
 (
    select
        *
    
    from cte_filter_stg_orfi_groupe
    --left join cte_stg_reference on ....
    --left join cte_stg_orfi_group on ....
 ),


-------------------------------------------------------------------
--********************** CLES TECHNIQUES *************************
-------------------------------------------------------------------
cte_hk_calc_stg_orfi_groupe as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_groupe_id as varchar(max))
    
)  
 
         as orfi_groupe_hk
    from 
        cte_calc_stg_orfi_groupe
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
        cte_hk_calc_stg_orfi_groupe
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale