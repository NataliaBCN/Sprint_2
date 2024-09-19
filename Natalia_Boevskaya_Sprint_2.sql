-- ***************************************************************************************************************
-- Nivell 1
-- Exercici 2
-- Utilitzant JOIN realitzaràs les següents consultes:
-- Llistat dels països que estan fent compres.
select distinct country
from company  inner join transaction on company.id=transaction.company_id

;

-- Des de quants països es realitzen les compres.
select 
	count(distinct country) as Num_paises
from 
	company  inner join transaction on company.id=transaction.company_id
;

-- Identifica la companyia amb la mitjana més gran de vendes.

select 
	c.company_name,
	avg(t.amount)
from 
	transaction t left outer join company c on c.id=t.company_id
group by 
	t.company_id
order by 
	avg(t.amount) desc
limit 1
;
-- Exercici 3
-- Utilitzant només subconsultes (sense utilitzar JOIN):
-- Mostra totes les transaccions realitzades per empreses d'Alemanya.
select 
	*
from 
	transaction
where 
	company_id in 	(select id
					from company
					where country='Germany')
;
-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
select 
	company_name 
from 
	company
where 
	id in	(select company_id
			from transaction
			where amount > (select avg(amount) 
							from transaction)
			);
-- Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
select company_name
from company
where id not in (select distinct company_id
				from transaction)
;
-- ***************************************************************************************************************
-- Nivell 2
-- Exercici 1
-- Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data de cada transacció juntament amb el total de les vendes.
select 
	CAST(timestamp AS DATE) as Date, 
	sum(amount) as Sum_Ventas_en_fecha
from 	
		transaction
group by 
	CAST(timestamp AS DATE)
order by 
	sum(amount) desc
limit 5				
;
-- Exercici 2
-- Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.

select 	c.country as Country,
		sum(t.amount)/count(t.id) as Avg_Ventas
from transaction t left outer join company c on t.company_id=c.id
group by c.country
order by Avg_Ventas desc
;
-- Exercici 3

-- En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute". Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.

-- Mostra el llistat aplicant JOIN i subconsultes.
select *
from 
	company  inner join transaction on company.id=transaction.company_id
where company.country in (	select country
							from company
							where company_name='Non Institute') 
	    
;
-- Mostra el llistat aplicant solament subconsultes.

select *
from 
	transaction
where transaction.company_id in (	select id
									from company
									where country=(	select country
													from company
													where company_name='Non Institute') 
                                                    
)
;
-- ***************************************************************************************************************                                                    
-- Nivell 3
-- Exercici 1
-- Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 100 i 200 euros i en alguna d'aquestes dates: 29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022. Ordena els resultats de major a menor quantitat.
select
	c.company_name,
    c.phone,
    c.country,
    cast(t.timestamp as date) as data,
    t.amount
from 
	transaction t left outer join company c on t.company_id=c.id
where
	(t.amount  between 100 and 200) and
  cast(t.timestamp as date) in('2021-04-29','2021-07-20','2022-03-13') -- 29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022
order by t.amount desc
 ;   
-- Exercici 2
-- Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.


-- Opcion 1 Solucion con CASE
select
	company_name,
	count(t.id) as num_transactions,
	if ( count(t.id) <4 ,  'less than 4',  '4 or more') as range_num_transactions
from 
	transaction t left outer join company c on t.company_id=c.id
group by 
	c.company_name
order by count(t.id)  desc
;
