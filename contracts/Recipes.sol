pragma solidity 0.5.0;

import "./ERC721Full.sol";

contract Recipes is ERC721Full {

    struct Recipe {
        string nombre;
        string dosis;
        string unidad;
        string frecuencia;
        string lapso;
        string descripcion;
        string tipo;
    }

    mapping(uint256 => Recipe) public recipes;

    constructor() ERC721Full("Recipe", "RECIPE") public {
    }

    event addedRecipe();

    // E.G. color = "#FFFFFF"
    function mint(
        string memory _nombre,
        string memory _dosis,
        string memory _unidad,
        string memory _frecuencia,
        string memory _lapso,
        string memory _descripcion,
        string memory _tipo
    ) public {
        uint _id = recipes.push(
            Recipe(
                _nombre,
                _dosis,
                _unidad,
                _frecuencia,
                _lapso,
                _descripcion,
                _tipo
            )
        );
        _mint(msg.sender, _id);
        emit addedRecipe();
    }

}

