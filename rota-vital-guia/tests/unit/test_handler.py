import json

from hello_world import app


def evento(corpo):
    """Evento mínimo do API Gateway (só o que a função usa)."""
    return {"httpMethod": "POST", "path": "/guias",
            "body": json.dumps(corpo) if corpo is not None else None}


def test_gera_guia_com_201():
    ret = app.lambda_handler(evento({"requisicaoId": "R-001",
                                     "hospital": "H-Recife",
                                     "bolsas": ["O-NEG-0142"]}), None)
    dados = json.loads(ret["body"])

    assert ret["statusCode"] == 201
    assert dados["guia"] == "G-R-001"
    assert dados["hospital"] == "H-Recife"
    assert dados["bolsas"] == ["O-NEG-0142"]
    assert dados["invocacaoNesteAmbiente"] >= 1


def test_sem_requisicao_id_retorna_400():
    ret = app.lambda_handler(evento({"hospital": "H-Recife"}), None)

    assert ret["statusCode"] == 400
    assert "requisicaoId" in json.loads(ret["body"])["erro"]


def test_corpo_vazio_retorna_400():
    ret = app.lambda_handler(evento(None), None)

    assert ret["statusCode"] == 400


def test_contador_global_cresce_no_mesmo_processo():
    antes = app.contador
    app.lambda_handler(evento({"requisicaoId": "R-X"}), None)

    assert app.contador == antes + 1
