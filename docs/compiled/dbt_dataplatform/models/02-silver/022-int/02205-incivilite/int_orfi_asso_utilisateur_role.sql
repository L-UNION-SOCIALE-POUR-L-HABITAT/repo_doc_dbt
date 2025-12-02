/**
 *
 * Description :    Alimentation de la table intermediate int_orfi_asso_utilisateur_role
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          stg_orfi_asso_utilisateur_role
 * Cible :          int_orfi_asso_utilisateur_role
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_orfi_asso_utilisateur_role as 
(
    select 
        orfi_asso_utilisateur_role_id_code,
        orfi_utilisateur_id_code,
        orfi_role_id_code
        
      
    from 
        "wh_dp_silver"."stg"."stg_orfi_asso_utilisateur_role"
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
cte_filter_stg_orfi_asso_utilisateur_role as 
(
    select 
        *
        
    from 
        cte_stg_orfi_asso_utilisateur_role

),



-------------------------------------------------------------------
--************* JOINTURE ET COLONNES CALCULEES ********************
-------------------------------------------------------------------
cte_calc_stg_orfi_asso_utilisateur_role  as 
 (
    select
        *
    
    from cte_filter_stg_orfi_asso_utilisateur_role
    --left join cte_stg_reference on ....
    --left join cte_stg_orfi_group on ....
 ),


-------------------------------------------------------------------
--********************** CLES TECHNIQUES *************************
-------------------------------------------------------------------
cte_hk_calc_stg_orfi_asso_utilisateur_role as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_asso_utilisateur_role_id_code as varchar(max))
    
)  
 
         as orfi_asso_utilisateur_role_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_role_id_code as varchar(max))
    
)  
 
                           as orfi_role_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_utilisateur_id_code as varchar(max))
    
)  
 
                    as orfi_utilisateur_hk

        
    from 
        cte_calc_stg_orfi_asso_utilisateur_role
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
        cte_hk_calc_stg_orfi_asso_utilisateur_role
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale