

-- Table source
with base as (
    select
        qpv_annee,
        qpv_code,
        qpv_libelle,
        commune_code_liste,
        len(commune_code_liste) / 5 as nb_communes
    from "wh_dp_silver"."stg"."stg_insee_appartenance_geo_qpv24"
),

-- Table de nombres de 1 à 15

numbers as (
    select row_number() over (order by (select null)) as idx
    from openjson(replicate('{"x":0},', 15) + '{"x":0}')
),


-- Découpage des codes communes
exploded as (
    select
        b.qpv_annee,
        b.qpv_code,
        b.qpv_libelle,
        substring(b.commune_code_liste, ((n.idx - 1) * 5) + 1, 5) as commune_code
    from base b
    join numbers n
        on n.idx <= b.nb_communes
)

-- Résultat final filtré
select *
from exploded