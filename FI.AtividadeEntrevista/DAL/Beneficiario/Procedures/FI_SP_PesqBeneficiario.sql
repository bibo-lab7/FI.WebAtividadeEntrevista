﻿CREATE PROC FI_SP_PesqBeneficiario
	@iniciarEm int,
	@quantidade int,
	@campoOrdenacao varchar(200),
	@crescente bit	
AS
BEGIN
	DECLARE @SCRIPT NVARCHAR(MAX)
	DECLARE @CAMPOS NVARCHAR(MAX)
	DECLARE @ORDER VARCHAR(50)
	
	SET @ORDER = ' NOME '

	IF(@crescente = 0)
		SET @ORDER = @ORDER + ' DESC'
	ELSE
		SET @ORDER = @ORDER + ' ASC'

	SET @CAMPOS = '@iniciarEm int,@quantidade int'
	
	SET @SCRIPT = 
	'SELECT BENEFICIARIOS.ID, BENEFICIARIOS.NOME, BENEFICIARIOS.CPF, CLIENTES.NOME FROM
		(SELECT ROW_NUMBER() OVER (ORDER BY ' + @ORDER + ') AS Row, BENEFICIARIOS.ID, BENEFICIARIOS.NOME, BENEFICIARIOS.CPF, CLIENTES.NOME FROM BENEFICIARIOS JOIN CLIENTES WITH(NOLOCK))
		AS ClientesWithRowNumbers
	WHERE Row > @iniciarEm AND Row <= (@iniciarEm+@quantidade) ORDER BY'
	
	SET @SCRIPT = @SCRIPT + @ORDER
			
	EXECUTE SP_EXECUTESQL @SCRIPT, @CAMPOS, @iniciarEm, @quantidade

	SELECT COUNT(1) FROM BENEFICIARIOS WITH(NOLOCK)
END