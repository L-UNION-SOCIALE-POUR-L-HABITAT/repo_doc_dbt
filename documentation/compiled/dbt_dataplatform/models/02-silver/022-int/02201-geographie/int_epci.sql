/**
 *
 * Description :    Alimentation de la table intermediate int_epci
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          stg_insee_epci, map_epci_nature_code
 * Cible :          int_epci 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_insee_epci as 
(
    select 
        epci_annee,
        epci_code,
        epci_libelle,
        epci_nature_code

    from 
        "wh_dp_silver"."stg"."stg_insee_epci"
),

cte_map_epci_nature_code as
(
    select
        epci_nature_code_source,
        epci_nature_code_cible       
    from
        "wh_dp_bronze"."seed"."map_epci_nature_code"
),

-- Ajout des colonnes calculées
 cte_calc_stg_insee_epci  as 
 (
    select
        t1.epci_annee                             as epci_annee,
        t1.epci_code                              as epci_code,
        case 
			when t1.epci_libelle like 'Communauté urbaine%' then replace (t1.epci_libelle, 'Communauté urbaine', 'CU')
			when t1.epci_libelle like 'Communauté d''agglomération%' then replace (t1.epci_libelle, 'Communauté d''agglomération', 'CA')
			when t1.epci_libelle like 'Communauté de communes%' then replace (t1.epci_libelle, 'Communauté de communes', 'CC')
			else t1.epci_libelle
		end AS epci_libelle, 
        cte_map_epci_nature_code.epci_nature_code_cible           as epci_nature_code
        , 
    case
        when t1.epci_annee = (
            select max(t2.epci_annee)
            from "wh_dp_silver"."stg"."stg_insee_epci" t2
            where t2.epci_code = t1.epci_code
        ) then 1
        else 0
    end
 as epci_annee_last_flag

    from 
        cte_stg_insee_epci t1
    
    left join
        cte_map_epci_nature_code
    on
        t1.epci_nature_code = cte_map_epci_nature_code.epci_nature_code_source
 ),


-- Ajout des clés techniques
cte_hk_calc_insee_epci as
(
    select 
        *
        , 
    
        concat_ws('||', epci_annee, epci_code) 
    
 as epci_bk
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', epci_annee, epci_code) 
    
)  
 
 as epci_hk
    from 
        cte_calc_stg_insee_epci
),

 cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_insee_epci
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale