# Latexmk Konfiguration für glossaries (via makeglossaries) - Versuch 4

my $perl_path = '/usr/bin/perl'; 
my $makeglossaries_script = '/Library/TeX/texbin/makeglossaries';

# Subroutine, die Pfade aus $_[0] (z.B. "Arbeit/out/main") extrahiert
sub run_makeglossaries_from_arg0 {
    my $full_prefix = $_[0]; # Das Argument, das latexmk übergibt

    print "Latexmk: Received full prefix from latexmk: '$full_prefix'\n";

    # Extrahiere Output-Verzeichnis und Basisnamen
    my $output_dir = $full_prefix;
    my $base_name = $full_prefix;

    # Nutze Regex, um Pfad/Datei zu trennen (funktioniert für / und \)
    if ($full_prefix =~ m/^(.*)[\\\/]([^\\\/]+)$/) { 
        $output_dir = $1; # Alles vor dem letzten Slash/Backslash
        $base_name = $2;  # Alles nach dem letzten Slash/Backslash
    } else {
        # Fallback, falls kein Pfad enthalten (sollte hier nicht passieren)
        $output_dir = '.'; 
        $base_name = $full_prefix;
    }

    print "Latexmk: Extracted OutDir: '$output_dir', BaseName: '$base_name'\n";
    print "Latexmk: Running makeglossaries for '$base_name' in '$output_dir' via Perl...\n";

    # Baue den Befehl zusammen: perl script -d <outdir> <basename>
    # Jetzt mit den korrekt extrahierten Werten!
    my $return_code = system(
        $perl_path, 
        $makeglossaries_script, 
        "-d", $output_dir,  # Explizit das korrekte Zielverzeichnis angeben
        $base_name         # Explizit den korrekten Basisnamen angeben
    );

    if ($return_code) {
        warn "Latexmk: makeglossaries run failed with exit code $return_code\n";
    }
    return $return_code;
}

# Verwende die NEUE Subroutine
add_cus_dep('glo', 'gls', 0, 'run_makeglossaries_from_arg0');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries_from_arg0');

$clean_ext .= ' %R.glo %R.gls %R.glg %R.acn %R.acr %R.alg %R.ist';
# Füge Output-Ordner zum Aufräumen hinzu
$clean_ext .= " Arbeit/out/*";