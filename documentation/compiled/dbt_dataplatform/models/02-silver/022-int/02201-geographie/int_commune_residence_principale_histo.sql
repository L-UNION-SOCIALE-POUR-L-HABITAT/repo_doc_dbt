-- -----------------------------------------------------------------------------
-- Description :
--   Ce modèle alimente la table intermediate `int_commune_residence_principale_histo`.
--   Il a pour rôle de compléter l’historique des communes en générant les années
--   manquantes et en propageant la dernière valeur connue.
--
-- Fréquence :
--   Annuel
--
-- Mode :
--   Insert / Update
--
-- Source :
--   `stg_insee_commune_residence_principale_histo`
--
-- Cible :
--   `int_commune_residence_principale_histo`
--
-- Détails :
--   - Nous recevons chaque année un seul fichier contenant l’historique complet.
--   - Le fichier est conservé dans le Lakehouse avec son année de récupération
--     ajoutée à la fin du nom du fichier.
--   - La table `raw_insee_commune_residence_principale_histo` ne contient que
--     la dernière version disponible.
--   - Le présent traitement enrichit les données en ajoutant les années manquantes.
--
-- Exemple :
--   Données brutes :
--     1968 | Cabourg | 10 000
--     1971 | Cabourg | 15 000
--
--   Données finales :
--     1968 | Cabourg | 10 000
--     1969 | Cabourg | 10 000
--     1970 | Cabourg | 10 000
--     1971 | Cabourg | 15 000
--     1972 | Cabourg | 15 000
-- -----------------------------------------------------------------------------




-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
with
-- Selection des colonnes
cte_stg_insee_commune_residence_principale_histo as (
    select 
        commune_code,
        commune_annee,
        logements_prives_nombre
    from "wh_dp_silver"."stg"."stg_insee_commune_residence_principale_histo"
),

-------------------------------------------------------------------
--*********************** TRANSFORMATION *************************
-------------------------------------------------------------------
  
-- Liste des années complètes depuis la date min jusqu'a annee actuelle + 1
years as (
    select value as commune_annee
    from generate_series(
        (select cast(min(commune_annee) as int) from cte_stg_insee_commune_residence_principale_histo),
        year(getdate()) + 1
    )
),

-- Liste unique des communes
communes as (
    select distinct commune_code from cte_stg_insee_commune_residence_principale_histo
),

-- Produit croisé commune × année
combinations as (
    select 
        y.commune_annee,
        c.commune_code
    from years y
    cross join communes c
),

-- Jointure avec cte_stg_insee_commune_residence_principale_histo
joined as (
    select 
        comb.commune_annee,
        comb.commune_code,
        src.logements_prives_nombre
    from combinations comb
    left join cte_stg_insee_commune_residence_principale_histo src
        on comb.commune_code = src.commune_code
       and comb.commune_annee = src.commune_annee
),

-- Propagation des valeurs manquantes
filled as (
    select
        commune_annee,
        commune_code,
        max(logements_prives_nombre) over (
            partition by commune_code
            order by commune_annee
            rows between unbounded preceding and current row
        ) as logements_prives_nombre
    from joined
),

-------------------------------------------------------------------
--*********************** FINAL *************************
-------------------------------------------------------------------
cte_finale as 
(
select
    *,
    
     
        HASHBYTES('SHA2_256', 
    
        cast(commune_code as varchar(max))
    
)  
 
 as commune_code_hk,
    
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
          as _meta_loaded_at
from filled
)

select 
    *
from cte_finale