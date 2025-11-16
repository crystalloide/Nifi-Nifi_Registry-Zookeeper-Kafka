USE sampledb;

CREATE TABLE personnes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    adresse VARCHAR(100) NOT NULL
);

INSERT INTO personnes (nom, prenom, adresse) VALUES
('Martin', 'Pierre', '12 Rue des Oliviers, Paris'),
('Dubois', 'Sophie', '45 Avenue Victor Hugo, Lyon'),
('Leroy', 'Thomas', '8 Boulevard Gambetta, Marseille'),
('Petit', 'Marie', '3 Rue de la République, Lille'),
('Moreau', 'Jean', '22 Cours Franklin Roosevelt, Bordeaux'),
('Laurent', 'Julie', '7 Place Bellecour, Lyon'),
('Simon', 'Philippe', '18 Rue du Faubourg Saint-Antoine, Paris'),
('Michel', 'Nathalie', '5 Quai des Chartrons, Bordeaux'),
('Bernard', 'François', '30 Canebière, Marseille'),
('Richard', 'Isabelle', '14 Grand Place, Lille');