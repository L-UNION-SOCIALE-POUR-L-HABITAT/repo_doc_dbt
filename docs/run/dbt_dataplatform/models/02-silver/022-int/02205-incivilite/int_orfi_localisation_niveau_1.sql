
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "int"."int_orfi_localisation_niveau_1__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table intermediate int_orfi_localisation_niveau_1
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          stg_orfi_localisation_niveau_1
 * Cible :          int_orfi_localisation_niveau_1
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_orfi_localisation_niveau_1 as 
(
    select 
        orfi_localisation_niveau_1_id,
        orfi_localisation_niveau_1_libelle
        
    from 
        "wh_dp_silver"."stg"."stg_orfi_localisation_niveau_1"
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
cte_filter_stg_orfi_localisation_niveau_1 as 
(
    select 
        *
        
    from 
        cte_stg_orfi_localisation_niveau_1

),



-------------------------------------------------------------------
--************* JOINTURE ET COLONNES CALCULEES ********************
-------------------------------------------------------------------
cte_calc_stg_orfi_localisation_niveau_1  as 
 (
    select
        *
    
    from cte_filter_stg_orfi_localisation_niveau_1
    --left join cte_stg_reference on ....
    --left join cte_stg_orfi_group on ....
 ),


-------------------------------------------------------------------
--********************** CLES TECHNIQUES *************************
-------------------------------------------------------------------
cte_hk_calc_stg_orfi_localisation_niveau_1 as
(
    select 
        *
        , 
     
        HASHBYTES(''SHA2_256'', 
    
        cast(orfi_localisation_niveau_1_id as varchar(max))
    
)  
 
         as orfi_localisation_niveau_1_hk
    from 
        cte_calc_stg_orfi_localisation_niveau_1
),
 
-------------------------------------------------------------------
--********************** ETAPE FINALE *************************
-------------------------------------------------------------------
 
 cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_stg_orfi_localisation_niveau_1
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."int"."int_orfi_localisation_niveau_1__dbt_temp" AS SELECT * FROM "wh_dp_silver"."int"."int_orfi_localisation_niveau_1__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  