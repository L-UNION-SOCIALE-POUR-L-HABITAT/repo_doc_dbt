
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "int"."int_demandeur_foyer__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table intermediate int_demandeur_foyer
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          stg_gipsne_ele_desc_foyer_demande       
                    int_demandeur_lien      
 * Cible :          int_demandeur_foyer
 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_stg_gipsne_ele_desc_foyer_demande as 
(
    select 
        demandeur_foyer_demande_id,
        demandeur_type_code,
        demandeur_foyer_naissance_date,
        demandeur_foyer_age,
        demandeur_foyer_ordre_affichage, 
        demandeur_lien_cle,
        demandeur_foyer_annee 

    from "wh_dp_silver"."stg"."stg_gipsne_ele_desc_foyer_demande"
),

 
cte_int_demandeur_lien as
(
    select  
        demandeur_lien_cle
        , demandeur_lien_code
    from 
        "wh_dp_silver"."int"."int_demandeur_lien"
),

-------------------------------------------------------------------
--*********************** TRANSFORMATIONS *************************
-------------------------------------------------------------------
 
cte_calc_stg_gipsne_ele_desc_foyer_demande as
(
    select 
        stg.demandeur_foyer_demande_id
        , stg.demandeur_type_code
        , isnull(ref.demandeur_lien_code,''N/A'') 
                as demandeur_lien_code
        , stg.demandeur_lien_cle
        , stg.demandeur_foyer_naissance_date
        , stg.demandeur_foyer_age
        , stg.demandeur_foyer_annee
        , stg.demandeur_foyer_ordre_affichage
        , 
    case
        when (demandeur_foyer_annee) = (
            select max((demandeur_foyer_annee))
            from cte_stg_gipsne_ele_desc_foyer_demande
        ) then 1
        else 0
    end

                as demandeur_foyer_annee_last_flag

    from 
        cte_stg_gipsne_ele_desc_foyer_demande stg
    left join
        cte_int_demandeur_lien ref
        on stg.demandeur_lien_cle = ref.demandeur_lien_cle
    
),

--ajout des clés techniques
cte_hk_calc_stg_gipsne_ele_desc_foyer_demande as
(
    select
        *
        ,
    
        concat_ws(''||'', demandeur_foyer_annee, demandeur_foyer_demande_id, demandeur_foyer_ordre_affichage) 
    
 
                            as demandeur_foyer_bk  
        ,
     
        HASHBYTES(''SHA2_256'', 
    
        concat_ws(''||'', demandeur_foyer_annee, demandeur_foyer_demande_id, demandeur_foyer_ordre_affichage) 
    
)  
 
 
                            as demandeur_foyer_hk 
        ,
     
        HASHBYTES(''SHA2_256'', 
    
        cast(demandeur_type_code as varchar(max))
    
)  
 
 
                            as demandeur_type_hk
        ,
     
        HASHBYTES(''SHA2_256'', 
    
        cast(demandeur_lien_code as varchar(max))
    
)  
 
 
                            as demandeur_lien_hk   
        ,
     
        HASHBYTES(''SHA2_256'', 
    
        concat_ws(''||'', demandeur_foyer_annee, demandeur_foyer_demande_id) 
    
)  
 
 
                            as demande_et_radiation_sne_hk
    from 
        cte_calc_stg_gipsne_ele_desc_foyer_demande
),

-------------------------------------------------------------------
--*********************** ETAPE FINALE *************************
-------------------------------------------------------------------
cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_stg_gipsne_ele_desc_foyer_demande
 )

 
select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."int"."int_demandeur_foyer__dbt_temp" AS SELECT * FROM "wh_dp_silver"."int"."int_demandeur_foyer__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  