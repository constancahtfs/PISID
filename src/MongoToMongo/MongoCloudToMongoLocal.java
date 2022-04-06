package MongoToMongo;


public class MongoCloudToMongoLocal {


    public static void migrateData() {
        // Ir constantemente buscar dados ao mongo da cloud (Usar a classe MongoCloud)
        // Pensar numa forma de ir buscar dados não repetidos (guardar ultimo timestamp 'buscado'
        // num ficheiro por exemplo - eu adicionei o ficheiro a esta pasta)
    }


    public static void main(String[] args){
        migrateData();
    }

}
