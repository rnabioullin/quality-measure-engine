require './lib/tasks/measure_loader'

module QME
  module Database
  
    # Utility class for working with JSON files and the database
    class Loader
      # Create a new Loader. Database host and port may be set using the 
      # environment variables TEST_DB_HOST and TEST_DB_PORT which default
      # to localhost and 27017 respectively.
      # @param [String] db_name the name of the database to use
      def initialize(db_name)
        @db_name = db_name
        @db_host = ENV['TEST_DB_HOST'] || 'localhost'
        @db_port = ENV['TEST_DB_PORT'] ? ENV['TEST_DB_PORT'].to_i : 27017
      end
      
      # Lazily creates a connection to the database and initializes the
      # JavaScript environment
      # @return [Mongo::Connection]
      def get_db
        if @db==nil
          @db = Mongo::Connection.new(@db_host, @db_port).db(@db_name)
          QME::MongoHelpers.initialize_javascript_frameworks(@db)
        end
        @db
      end
      
      # Load a measure from the filesystem and save it in the database.
      # @param [String] measure_dir path to the directory containing a measure or measure collection document
      # @param [String] collection_name name of the database collection to save the measure into.
      # @return [Array] the stroed measures as an array of JSON measure hashes
      def save_measure(measure_dir, collection_name)
        measures = QME::Measure::Loader.load_measure(measure_dir)
        measures.each do |measure|
          save(collection_name, measure)
        end
        measures
      end
      
      # Save a JSON hash to the specified collection, creates the
      # collection if it doesn't already exist.
      # @param [String] collection_name name of the database collection
      # @param [Hash] json the JSON hash to save in the database 
      def save(collection_name, json)
        collection = get_db.create_collection(collection_name)
        collection.save(json)
      end
      
      # Drop a database collection
      # @param [String] collection_name name of the database collection
      def drop_collection(collection_name)
        get_db.drop_collection(collection_name)
      end
    end
  end
end