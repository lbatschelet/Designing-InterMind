\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{template}[2024/12/19 My custom template class]

% Basierend auf article
\LoadClass[10pt,a4paper]{article}

% ---------------------- Pakete für Layout ----------------------
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{helvet}    % Serifenlose Schrift für Titel und Überschriften
\RequirePackage{ragged2e}
\RequirePackage{lipsum}
\RequirePackage{mathptmx}  % Times-ähnliche Schrift für den Fliesstext
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}
\RequirePackage{amsfonts}
\RequirePackage{amscd}
\RequirePackage{amsthm}
\renewcommand{\sfdefault}{phv}

\RequirePackage[nswissgerman]{babel}

\RequirePackage{geometry}
\geometry{a4paper, left=3cm, right=3cm, top=2.5cm, bottom=2.5cm}

\RequirePackage{setspace}
\onehalfspacing

\RequirePackage{microtype}
\DisableLigatures{encoding = *, family = * }

\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=black,
    citecolor=TealBlue,
    urlcolor=TealBlue
}

\RequirePackage{cleveref}
\crefname{section}{Abschnitt}{Abschnitte}
\crefname{subsection}{Abschnitt}{Abschnitte}
\crefname{figure}{Abbildung}{Abbildungen}
\crefname{table}{Tabelle}{Tabellen}
\crefname{equation}{Gleichung}{Gleichungen}
\crefname{chapter}{Kapitel}{Kapitel}



\RequirePackage{titlesec}
\titleformat{\section}{\sffamily\Large\bfseries\raggedright}{\thesection}{1em}{} 
\titleformat{\subsection}{\sffamily\large\bfseries\raggedright}{\thesubsection}{1em}{}
\titleformat{\subsubsection}{\sffamily\normalsize\bfseries\raggedright}{\thesubsubsection}{1em}{}

\RequirePackage{enumitem}

\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
% Keine Linien:
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
% Seitenzahl unten rechts:
\fancyfoot[R]{\thepage}

% ---------------------- Literatur mit biblatex ----------------------
\RequirePackage[
  style=authoryear,     
  backend=biber,
  giveninits=false,     % Volle Vornamen
  maxbibnames=999,      % Alle Namen im Verzeichnis
  date=year,            % Nur das Jahr anzeigen
  uniquename=false,
  language=swissgerman,
  doi=true,             % DOI anzeigen (wichtig!)
  % url=false,          % << DIESE ZEILE ENTFERNEN oder auskommentieren!
  isbn=false,
  eprint=false
]{biblatex}

% Befehle zum einfachen Einbinden der Bib-Datei und Ausgeben der Bibliographie:
\newcommand{\AddBibFile}[1]{\addbibresource{#1}}
\newcommand{\PrintBib}{\printbibliography}

\DefineBibliographyStrings{nswissgerman}{%
  andothers = {et\addabbrvspace al\adddot} % Definiert "und andere" als "et al."
}

% Makro für URL-Ausgabe anpassen: Nur ausgeben, wenn kein DOI vorhanden ist
\renewbibmacro*{url+urldate}{% Sternchen-Version für saubere Neudefinition
  \iffieldundef{doi} % Prüfe, ob das Feld 'doi' undefiniert/leer ist
    {% Wenn KEIN DOI da ist: Gib URL und Abrufdatum aus
      \usebibmacro{url}% Holt sich die Standard-URL-Formatierung
      \setunit*{\addspace}% Fügt Leerschlag ein, wenn nötig
      \usebibmacro{urldate}% Holt sich die Standard-Abrufdatum-Formatierung
    }
    {% Wenn EIN DOI da ist: Tue nichts (gib keine URL/Abrufdatum aus)
    }%
}


% ---------------------- Titel- und Metainformationen ----------------------
\newcommand{\ReportTitle}{}
\newcommand{\ReportAuthor}{}
\newcommand{\ReportDate}{\today}

\newcommand{\SetTitle}[1]{\renewcommand{\ReportTitle}{#1}}
\newcommand{\SetAuthor}[1]{\renewcommand{\ReportAuthor}{#1}}
\newcommand{\SetDate}[1]{\renewcommand{\ReportDate}{#1}}

\makeatletter
\renewcommand{\maketitle}{
    % Titel in serifenlos und linksbündig
    \vspace*{-2em}
    \sffamily
    \raggedright
    {\Large\bfseries \ReportTitle \par}
    \vspace{1em}
    {\footnotesize
        \ReportAuthor \\
        \ReportDate
    }
    \par\vspace{2em}

    % Nach dem Titel wieder zurück zu Times (Serif) und Blocksatz
    \normalfont
    \normalsize
    \rmfamily
    \justifying
}
\makeatother
