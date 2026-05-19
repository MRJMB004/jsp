package com.cooperative.util;

import com.cooperative.model.Reservation;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;
import java.io.OutputStream;
import java.text.SimpleDateFormat;

public class PDFGenerator {

    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMMM yyyy");
    private static final SimpleDateFormat dateTimeFormat = new SimpleDateFormat("dd MMMM yyyy à HH:mm");

    public static void generateRecu(Reservation r, OutputStream out) {
        Document document = new Document(PageSize.A6, 30, 30, 30, 30);

        try {
            PdfWriter.getInstance(document, out);
            document.open();

            // Polices
            Font fontTitre = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
            Font fontSousTitre = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
            Font fontNormal = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL);
            Font fontItalic = new Font(Font.FontFamily.HELVETICA, 11, Font.ITALIC);

            // En-tête
            Paragraph entete = new Paragraph("COOPÉRATIVE DE TRANSPORT", fontTitre);
            entete.setAlignment(Element.ALIGN_CENTER);
            document.add(entete);

            Paragraph sousEntete = new Paragraph("Reçu de réservation", fontItalic);
            sousEntete.setAlignment(Element.ALIGN_CENTER);
            document.add(sousEntete);

            document.add(new Paragraph(" "));

            // Numéro de reçu
            Paragraph numRecu = new Paragraph("Reçu N°" + r.getIdreserv(), fontSousTitre);
            numRecu.setAlignment(Element.ALIGN_CENTER);
            document.add(numRecu);

            document.add(new Paragraph(" "));
            document.add(new LineSeparator());
            document.add(new Paragraph(" "));

            // Informations de réservation
            document.add(new Paragraph("Date de réservation : " +
                    dateTimeFormat.format(r.getDateReserv()), fontNormal));
            document.add(new Paragraph("Date du voyage : " +
                    dateFormat.format(r.getDateVoyage()), fontNormal));

            document.add(new Paragraph(" "));

            // Informations client
            document.add(new Paragraph("Client : " + r.getNomClient(), fontNormal));
            document.add(new Paragraph("Contact : " + r.getNumtelClient(), fontNormal));

            document.add(new Paragraph(" "));

            // Informations voiture
            document.add(new Paragraph("Voiture : " + r.getDesignVoiture() +
                    " (N°" + r.getIdvoit() + ")", fontNormal));
            document.add(new Paragraph("Type : " + r.getTypeVoiture(), fontNormal));
            document.add(new Paragraph("Place N° : " + r.getPlace(), fontNormal));

            document.add(new Paragraph(" "));

            // Informations paiement
            document.add(new Paragraph("Frais total : " +
                    String.format("%,d", r.getFraisVoiture()) + " Ar", fontNormal));
            document.add(new Paragraph("Mode de paiement : " + r.getPayment(), fontNormal));

            if ("avec avance".equals(r.getPayment())) {
                document.add(new Paragraph("Montant avance : " +
                        String.format("%,d", r.getMontantAvance()) + " Ar", fontNormal));
                document.add(new Paragraph("Reste à payer : " +
                        String.format("%,d", r.getReste()) + " Ar", fontSousTitre));
            } else if ("tout payé".equals(r.getPayment())) {
                document.add(new Paragraph("Montant payé : " +
                        String.format("%,d", r.getFraisVoiture()) + " Ar", fontNormal));
            }

            document.add(new Paragraph(" "));
            document.add(new LineSeparator());
            document.add(new Paragraph(" "));

            // Signature
            Paragraph signature = new Paragraph("Signature de la coopérative", fontItalic);
            signature.setAlignment(Element.ALIGN_RIGHT);
            document.add(signature);

            Paragraph date = new Paragraph("Fait le " + dateFormat.format(new java.util.Date()), fontItalic);
            date.setAlignment(Element.ALIGN_RIGHT);
            document.add(date);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            document.close();
        }
    }
}