// libraries used
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

    //create 4x4 map squares (each array is part of a square)
    double tileHP[][10] = { {0,0,0,10,0,0,0,0,0,0},
                            {0,0,0,0,0,0,0,0,10,10},
                            {0,0,0,0,0,0,10,0,0,0},
                            {0,0,0,0,0,0,10,0,0,0},
                            {0,0,0,0,0,0,0,0,0,0},
                            {0,0,0,0,10,0,0,0,0,0},
                            {0,0,0,0,0,0,0,0,0,0},
                            {0,0,0,0,0,0,10,0,0,0},
                            {0,0,0,0,0,0,0,10,0,0},
                            {0,0,0,0,0,0,0,0,0,0} };
    const char tileTerrain[][10] = {"PPPFRPPPCX",
                                    "PPPPPPPPCF",
                                    "PPPPPCRRRR",
                                    "BPPPPRPCPP",
                                    "PPPPPPFPPP",
                                    "PPPRCCPPPP",
                                    "PPPPPPFCPP",
                                    "PPPPPPCCPP",
                                    "PPPPPPPRRP",
                                    "YPBPPPPRPP"};
    char tileArmy[][10] = {"000X000000",
                           "00000000XX",
                           "000000X000",
                           "000000X000",
                           "0000000000",
                           "0000X00000",
                           "0000000000",
                           "000000X000",
                           "0000000X00",
                           "0000000000"};
    char tileUnit[][10] = {"000R000000",
                           "00000000AT",
                           "000000C000",
                           "000000A000",
                           "0000000000",
                           "0000T00000",
                           "0000000000",
                           "000000R000",
                           "0000000C00",
                           "0000000000"};

    // used to check if all enemy units are destroyed
    int checkAlive[][10] = { {0,0,0,1,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,1,1},
                             {0,0,0,0,0,0,1,0,0,0},
                             {0,0,0,0,0,0,1,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,1,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,1,0,0,0},
                             {0,0,0,0,0,0,0,1,0,0},
                             {0,0,0,0,0,0,0,0,0,0} };

    //global variables used
    int moves = 0;
    int funds = 24000;
    int powerCharge = 0;

    // function definitions
    void UpdateFunds(char playerUnit);
    double CalcDamage(int attackX, int attackY, int defendX, int defendY);
    void CalcPowerCharge(char aUnit, double aoHP, double anHP, char dUnit, double doHP, double dnHP);
    void BuildUnit();
    void MoveUnit();
    void AttackUnit();
    void ActivateCOP();
    void PromptPlayer();
    void PrintCOBoxAndMap();

// main function
int main() {

    // start by printing out CO and map information, then get first command from player
    PrintCOBoxAndMap();
    printf("\n---------------------------------------------\n\n");
    PromptPlayer();

    return 0;

}

// subtracts unit cost from current funds
void UpdateFunds(char playerUnit) {

    // R = Recon
    // T = Tank
    // A = Anti-Air
    // H = Helicopter
    if (playerUnit == 'R') {
        funds -= 4000;
    } else if (playerUnit == 'T') {
        funds -= 7000;
    } else if (playerUnit == 'A') {
        funds -= 8000;
    } else if (playerUnit == 'C') {
        funds -= 9000;
    } else {
        printf("Invalid unit entered\n");
    }

}

// calculates attacking battle damage and returns amount of damage to deal (0.0-10.0)
// called for attacking and counterattacking
double CalcDamage(int attackX, int attackY, int defendX, int defendY) {

    // useful variables
    int terrainBonus;
    int aHP = round(tileHP[attackX][attackY] + 0.4); // rounded attacker HP
    int dHP = round(tileHP[defendX][defendY] + 0.4); // rounded defender HP
    int baseDamage;
    double totalDamage;

    // generate random luck damage (0-9)
    srand(time(0));
    int luck = rand()%10;

    // change terrain defense from char to int
    if ( tileUnit[defendX][defendY] == 'R' ||
         tileUnit[defendX][defendY] == 'T' ||
         tileUnit[defendX][defendY] == 'A' ) {

        if ( (tileTerrain[defendX][defendY] == 'X') || (tileTerrain[defendX][defendY] == 'Y') ) {
            terrainBonus = 4;
        } else if ( (tileTerrain[defendX][defendY] == 'C') || (tileTerrain[defendX][defendY] == 'B') ) {
            terrainBonus = 3;
        } else if ( tileTerrain[defendX][defendY] == 'F' ) {
            terrainBonus = 2;
        } else if ( tileTerrain[defendX][defendY] == 'P' ) {
            terrainBonus = 1;
        } else if ( tileTerrain[defendX][defendY] == 'R' ) {
            terrainBonus = 0;
        } else {
            printf("Invalid terrain selected\n");
            terrainBonus = -1;
        }

    } else if ( tileUnit[defendX][defendY] == 'C' ) {
        terrainBonus = 0;
    } else {
        printf("Invalid terrain selected\n");
        terrainBonus = -1; 
    }

    // calculate base damage (%) if attacker is R = Recon
    if ( (tileUnit[attackX][attackY] == 'R') && (tileUnit[defendX][defendY] == 'R') ) {
        baseDamage = 35;
    } else if ( (tileUnit[attackX][attackY] == 'R') && (tileUnit[defendX][defendY] == 'T') ) {
        baseDamage = 6;
    } else if ( (tileUnit[attackX][attackY] == 'R') && (tileUnit[defendX][defendY] == 'A') ) {
        baseDamage = 4;
    } else if ( (tileUnit[attackX][attackY] == 'R') && (tileUnit[defendX][defendY] == 'C') ) {
        baseDamage = 12;
    }

    // calculate base damage (%) if attacker is T = Tank
    if ( (tileUnit[attackX][attackY] == 'T') && (tileUnit[defendX][defendY] == 'R') ) {
        baseDamage = 85;
    } else if ( (tileUnit[attackX][attackY] == 'T') && (tileUnit[defendX][defendY] == 'T') ) {
        baseDamage = 55;
    } else if ( (tileUnit[attackX][attackY] == 'T') && (tileUnit[defendX][defendY] == 'A') ) {
        baseDamage = 65;
    } else if ( (tileUnit[attackX][attackY] == 'T') && (tileUnit[defendX][defendY] == 'C') ) {
        baseDamage = 10;
    }

    // calculate base damage (%) if attacker is A = Anti-Air
    if ( (tileUnit[attackX][attackY] == 'A') && (tileUnit[defendX][defendY] == 'R') ) {
        baseDamage = 60;
    } else if ( (tileUnit[attackX][attackY] == 'A') && (tileUnit[defendX][defendY] == 'T') ) {
        baseDamage = 25;
    } else if ( (tileUnit[attackX][attackY] == 'A') && (tileUnit[defendX][defendY] == 'A') ) {
        baseDamage = 45;
    } else if ( (tileUnit[attackX][attackY] == 'A') && (tileUnit[defendX][defendY] == 'C') ) {
        baseDamage = 120;
    }

    // calculate base damage (%) if attacker is C = Helicopter 
    if ( (tileUnit[attackX][attackY] == 'C') && (tileUnit[defendX][defendY] == 'R') ) {
        baseDamage = 55;
    } else if ( (tileUnit[attackX][attackY] == 'C') && (tileUnit[defendX][defendY] == 'T') ) {
        baseDamage = 55;
    } else if ( (tileUnit[attackX][attackY] == 'C') && (tileUnit[defendX][defendY] == 'A') ) {
        baseDamage = 25;
    } else if ( (tileUnit[attackX][attackY] == 'C') && (tileUnit[defendX][defendY] == 'C') ) {
        baseDamage = 65;
    }

    // calculate total damage dealt (%) to defender
    totalDamage = (baseDamage+luck) * (aHP*0.1) * ( 0.01*(200 - (100 + (dHP*terrainBonus))) );

    // return total damage (0.0-10.0)
    // precision to 1 decimal place
    int temp = (int) totalDamage;
    return (double) temp/10.0;

}

// calculates and updates powerCharge based on how much damage (in funds) was dealt
void CalcPowerCharge(char aUnit, double aoHP, double anHP, char dUnit, double doHP, double dnHP) {

    int aHPLost = round(aoHP + 0.4) - round(anHP + 0.4); // rounded attcker HP lost
    int dHPLost = round(doHP + 0.4) - round(dnHP + 0.4); // rounded defender HP lost


    // calculate powerCharge based on attacker
    if (aUnit == 'R') {
        powerCharge += aHPLost*200;
    } else if (aUnit == 'T') {
        powerCharge += aHPLost*350;
    } else if (aUnit == 'A') {
        powerCharge += aHPLost*400;
    } else if (aUnit == 'C') {
        powerCharge += aHPLost*450;
    }

    // calculate powerCharge based on defender
    if (dUnit == 'R') {
        powerCharge += dHPLost*400;
    } else if (dUnit == 'T') {
        powerCharge += dHPLost*700;
    } else if (dUnit == 'A') {
        powerCharge += dHPLost*800;
    } else if (dUnit == 'C') {
        powerCharge += dHPLost*900;
    }

}

// prompts player to build R, T, A, or C unit on a base tile and updates funds
void BuildUnit() {

    // useful variables
    int x, y;
    char playerBuild;
    int check = 0;

    // prompts player to choose one of the 2 base tiles to build units from
    printf("Please choose a base to build from: 3 0 or 9 2\n");
    scanf("%d %d", &x, &y);

    // loops until the player chooses one of the 2 base tiles
    while (check == 0) {
        if (x == 3 && y == 0) {
            check = 1;
        } else if (x == 9 && y == 2) {
            check = 1;
        } else {
            printf("Please input valid base coordinates:\n");
            scanf("%d %d", &x, &y);
        }
    }

    // prompts player to build one of 4 units listed
    // R = Recon, T = Tank, A = Anti-Air, C = Helicopter
    printf("Please select a unit to build from the following list: R, T, A, C\n");
    scanf(" %c", &playerBuild);

    // loops until player chooses one of the 4 units listed
    while ( playerBuild != 'R' &&
            playerBuild != 'T' &&
            playerBuild != 'A' &&
            playerBuild != 'C' ) {
        printf("Please build a valid unit from the list:\n");
        scanf(" %c", &playerBuild);
    }

    // checks to see if the player has enough funds to build the unit selected
    // if not, error message is outputted and the function goes back to PromptPlayer()
    // if there is enough funds, the unit is built on the chosen base tile and the funds are updated
    if ( (playerBuild == 'R' && funds < 4000) ||
         (playerBuild == 'T' && funds < 7000) ||
         (playerBuild == 'A' && funds < 8000) ||
         (playerBuild == 'C' && funds < 9000) ) {

        printf("Insufficient funds\n\n");
        PromptPlayer();

    } else {

        // subtract built unit cost from funds
        UpdateFunds(playerBuild); 

        // build unit
        tileArmy[x][y] = 'Y';
        tileHP[x][y] = 10.0;
        tileUnit[x][y] = playerBuild;

        // print updated map and get next command
        printf("\n---------------------------------------------\n\n");
        PrintCOBoxAndMap();
        printf("\n---------------------------------------------\n\n");
        PromptPlayer();

    }

}

// prompts player to move one of their units if the conditions are met
void MoveUnit() {

    int begX, begY, endX, endY;

    // prompts play to enter the start and end coordinates of unit to move
    printf("Please enter the coordinates of a unit to move and where to move it: (Ex: 3 0 4 2)\n");
    scanf("%d %d %d %d", &begX, &begY, &endX, &endY);

    // checks to see if coordinates are legal ones
    // to be legal, coordinates must be: in map, starting with player's unit, 
    // ending on an empty tile, and within 4 spaces
    // if legal, the map is updated to show moved unit and PromptPlayer() is returned to
    if ( (begX < 0 || begX > 9) ||
         (begY < 0 || begY > 9) ||
         (endX < 0 || endX > 9) ||
         (endY < 0 || endY > 9) ) {

        printf("Coordinates are out of bounds\n");
        PromptPlayer();

    } else if ( tileArmy[begX][begY] != 'Y' ) {
        printf("Illegal unit or empty tile selected\n");
        PromptPlayer();
    } else if ( tileArmy[endX][endY] == 'X' || tileArmy[endX][endY] == 'Y' ) {
        printf("Illegal destination tile\n");
        PromptPlayer();
    } else if ( (abs(endX-begX)+abs(endY-begY)) > 4 ) {
        printf("Illegal movement range\n");
        PromptPlayer();
    } else {

        // increment move counter up by 1
        moves++;

        // end tile gets beg tile's unit
        tileUnit[endX][endY] = tileUnit[begX][begY];
        tileHP[endX][endY] = tileHP[begX][begY];
        tileArmy[endX][endY] = 'Y';

        // beggining tile gets reset
        tileUnit[begX][begY] = '0';
        tileHP[begX][begY] = 0;
        tileArmy[begX][begY] = '0';

        // print updated map and get next command
        printf("\n---------------------------------------------\n\n");
        PrintCOBoxAndMap();
        printf("\n---------------------------------------------\n\n");
        PromptPlayer();

    }

}

// prompts player to attack an enemy unit and update damage if the conditions are met
void AttackUnit() {

    // useful variables
    int i, j;
    int temp = 0;
    int won = 0;
    int attackX, attackY, defendX, defendY;

    printf("Please enter the coordinates of the attacking and defending units: (Ex: 3 0 3 1)\n");
    scanf("%d %d %d %d", &attackX, &attackY, &defendX, &defendY);

    // check if attack coordinates are legal
    // legal if: in map, in range, and correct unit armies are selected
    if ( (attackX < 0 || attackX > 9) ||
         (attackY < 0 || attackY > 9) ||
         (defendX < 0 || defendX > 9) ||
         (defendY < 0 || defendY > 9) ) {

        printf("Coordinates are out of bounds\n");
        PromptPlayer();

    } else if ( !(( (abs(defendX-attackX) == 1) && (abs(defendY-attackY == 0)) ) ||
                  ( (abs(defendX-attackX) == 0) && (abs(defendY-attackY) == 1)) ) ) {

        printf("Attack not in range\n");
        PromptPlayer();

    } else if ( !( (tileArmy[attackX][attackY] == 'Y') &&
                   (tileArmy[defendX][defendY] == 'X') ) ) {

        printf("Illegal units or empty tile selected\n");
        PromptPlayer();

    } else {

        // increment moves counter by 1
        moves++;

        // store old HP values to use for CalcPowerCharge
        double aoHP = tileHP[attackX][attackY];
        double doHP = tileHP[defendX][defendY];

        // calculate attacking damage done to defending unit and update HP of defending unit
        tileHP[defendX][defendY] -= CalcDamage(attackX, attackY, defendX, defendY);

        // decide whether to counterattack or destroy defending unit
        // if defending unit is destroyed, check if all enemy units are destroyed
        if (tileHP[defendX][defendY] <= 0.0) {

            checkAlive[defendX][defendY] = 0;

            for (i = 0; i < 10; i++) {
                for (j = 0; j < 10; j++) {
                    if (checkAlive[i][j] == 1) {
                        temp = 1;
                    }
                }
            }

            // if all enemy units are destroyed, game is over (won = 1)
            if (temp == 0) {
                won = 1;
            }

            CalcPowerCharge(tileUnit[attackX][attackY], aoHP, aoHP, tileUnit[defendX][defendY], doHP, 0.0);
            tileHP[defendX][defendY] = 0.0;
            tileUnit[defendX][defendY] = '0';
            tileArmy[defendX][defendY] = '0';

        } else {

            // calculate counterttacking damage done to attacking unit and update HP of attacking unit
            tileHP[attackX][attackY] -= CalcDamage(defendX, defendY, attackX, attackY);

            // decide whether attacking unit survives or gets destroyed
            if (tileHP[attackX][attackY] <= 0.0) {
                CalcPowerCharge(tileUnit[attackX][attackY], aoHP, 0.0, tileUnit[defendX][defendY], doHP, tileHP[defendX][defendY]);
                tileHP[attackX][attackY] = 0.0;
                tileUnit[attackX][attackY] = '0';
                tileArmy[attackX][attackY] = '0';
            } else {
                CalcPowerCharge(tileUnit[attackX][attackY], aoHP, tileHP[attackX][attackY], tileUnit[defendX][defendY], doHP, tileHP[defendX][defendY]);
            }

        }

        // if won condition is met, game is over and results are diplayed
        // otherwise contnue getting commands
        if (won == 1) {

            printf("You win\n");
            printf("Total moves taken: %d\n", moves);

        } else {

            // print updated map and get next command
            printf("\n---------------------------------------------\n\n");
            PrintCOBoxAndMap();
            printf("\n---------------------------------------------\n\n");
            PromptPlayer();

        }

    }

}

// each of the players units gain +2 HP (HP caps off at 10)
void ActivateCOP() {

    int i, j;

    // if not enough charge, don't activate COP and return to PromptPlayer()
    // else, players units gain +2 HP, print updated map, and return to PromptPlayer()
    if (powerCharge < 20000) {
        printf("Not enough charge\n");
        PromptPlayer();
    } else {

        powerCharge -= 20000;
        printf("Hyper Repair (All of your units gain +2 HP)\n");

        // all player units on board gain +2 HP (cap = 10.0) 
        for (i = 0; i < 10; i++) {
            for (j = 0; j < 10; j++) {
                if ( (tileArmy[i][j] == 'Y') && (tileHP[i][j] <= 8.0) && (tileHP[i][j] >= 0.0) ) {
                    tileHP[i][j] += 2.0;
                } else if ( (tileArmy[i][j] == 'Y') && (tileHP[i][j] <= 10.0) ) {
                    tileHP[i][j] == 10.0;
                }
            }
        }

        // print updated map and get next command
        printf("\n---------------------------------------------\n\n");
        PrintCOBoxAndMap();
        printf("\n---------------------------------------------\n\n");
        PromptPlayer();

    }

}

// prompts player to either build, move, attack, or activate their COP
void PromptPlayer() {

    char playerCommand[7] = "";

    // gets a command from the player (4 options)
    printf("Please select an action to take from the following list: Build, Move, Attack, COP\n");
    scanf("%s", &playerCommand);

    // checks if one of the four commands are selected (loops until one selected)
    while (strcmp("Build", playerCommand)!= 0 &&
           strcmp("Move", playerCommand)!= 0 &&
           strcmp("Attack", playerCommand)!= 0 &&
           strcmp("COP", playerCommand)!= 0 ) {

        printf("Please input a valid command from the list:\n");
        scanf("%s", &playerCommand);

    }

    // function calls other functions to execute each of the 4 commands
    if (strcmp("Build", playerCommand) == 0) {
        BuildUnit();
    } else if (strcmp("Move", playerCommand) == 0) {
        MoveUnit();
    } else if (strcmp("Attack", playerCommand) == 0) {
        AttackUnit();
    } else if (strcmp("COP", playerCommand) == 0) {
        ActivateCOP();
    }

}

// prints the CO box and map in 4x4 square formation
void PrintCOBoxAndMap() {

    // prints CO box information
    printf("CO: Andy\n");
    printf("Funds: $%d\n", funds);
    printf("Moves: %d\n", moves);
    printf("CO Meter: %d/20000\n", powerCharge);

    printf("\n---------------------------------------------\n\n");

    int i, j;

    // prints entire map in 4x4 square formation
    for (i = 0; i < 10; i++) {

        for (j = 0; j < 10; j++) {

            int temp = round(tileHP[i][j] + 0.4);

            if (temp == 10) {
                printf("%d%c ", temp, tileTerrain[i][j]);
            } else {
                printf("%d%c  ", temp, tileTerrain[i][j]);
            }

        }

        printf("\n");

        for (j = 0; j < 10; j++) {
            printf("%c%c  ", tileArmy[i][j], tileUnit[i][j]);
        }

        printf("\n\n");

    }

}


