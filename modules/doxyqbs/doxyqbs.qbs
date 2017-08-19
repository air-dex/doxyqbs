/// @file doxyqbs.qbs
import qbs
import 'doxyqbs-modutils.js'as DoxyUtils

Module {
	id: doxyqbs

	/// @brief Doxygen executable which will create documentation.
	property string doxygenExecutable: 'doxygen'

	/// @brief Doxygen configuration file.
	readonly property string DOXYFILE_FILETAG: 'doxyfile'

	/// @brief Doxygen configuration file.
	readonly property string GENERATED_DOC_FILETAG: 'doxygen_doc'

	/// @brief Creation Rule
	Rule {
		multiplex: true
		inputs: [doxyqbs.DOXYFILE_FILETAG]

		Artifact {
			fileTags: [doxyqbs.GENERATED_DOC_FILETAG]
		}

		outputFileTags: [doxyqbs.GENERATED_DOC_FILETAG]

		prepare: {
			var cmd = new Command(product.doxyqbs.doxygenExecutable, input.filePath);
			cmd.description = 'Generating documentation with Doxygen';
			cmd.highlight = 'filegen';
			return cmd;
		}

		alwaysRun: true
	}
}
