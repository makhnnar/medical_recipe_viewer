pragma solidity 0.5.0;

import "./ERC721Full.sol";
pragma experimental ABIEncoderV2;

contract Recipes is ERC721Full {

    enum RecipeType{ VERDE, AMARILLO, MORADO }

    struct Recipe {
        string nombre;
        string dosis;
        string unidad;
        string frecuencia;
        string lapso;
        string descripcion;
        RecipeType tipo;
        string id_creador;
    }

    Recipe[] public recipes;

    constructor() ERC721Full("Recipe", "RECIPE") public {
    }

    event addedRecipe();

    function getRecipe(uint pos) external view returns(string[] memory){
        string[] memory toReturn = new string[](8);
        toReturn[0] = recipes[pos].nombre;
        toReturn[1] = recipes[pos].dosis;
        toReturn[2] = recipes[pos].unidad;
        toReturn[3] = recipes[pos].frecuencia;
        toReturn[4] = recipes[pos].lapso;
        toReturn[5] = recipes[pos].descripcion;
        toReturn[6] = getTypeAsString(recipes[pos].tipo);
        toReturn[7] = recipes[pos].id_creador;
        return toReturn;
    }

    function getTypeAsString(RecipeType tipo) private pure returns(string memory){
        if(tipo==RecipeType.VERDE){
            return '0';
        }
        if(tipo==RecipeType.AMARILLO){
            return '1';
        }
        return '2';
    }

    function mint(
        string memory _nombre,
        string memory _dosis,
        string memory _unidad,
        string memory _frecuencia,
        string memory _lapso,
        string memory _descripcion,
        RecipeType _tipo,
        string memory _idCreador
    ) public {
        uint _id = recipes.push(
            Recipe(
                _nombre,
                _dosis,
                _unidad,
                _frecuencia,
                _lapso,
                _descripcion,
                _tipo,
                _idCreador
            )
        );
        _mint(msg.sender, _id);
        emit addedRecipe();
    }

}

