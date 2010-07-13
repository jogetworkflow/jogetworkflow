package org.enhydra.jawe.components.graph;

import java.awt.BorderLayout;
import java.util.List;

import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JToolBar;
import javax.swing.JViewport;
import javax.swing.SwingConstants;

import org.enhydra.jawe.ActionBase;
import org.enhydra.jawe.BarFactory;
import org.enhydra.jawe.JaWEAction;
import org.enhydra.jawe.JaWEComponent;
import org.enhydra.jawe.JaWEComponentView;
import org.enhydra.jawe.JaWEManager;
import org.enhydra.jawe.ResourceManager;
import org.enhydra.jawe.Utils;
import org.enhydra.jawe.XMLElementChoiceButton;
import org.enhydra.jawe.base.controller.JaWEType;
import org.enhydra.jawe.base.controller.JaWETypes;
import org.enhydra.jawe.components.graph.actions.SetActivityMode;
import org.enhydra.jawe.components.graph.actions.SetEndMode;
import org.enhydra.jawe.components.graph.actions.SetParticipantMode;
import org.enhydra.jawe.components.graph.actions.SetParticipantModeFreeTextExpression;
import org.enhydra.jawe.components.graph.actions.SetSelectMode;
import org.enhydra.jawe.components.graph.actions.SetStartMode;
import org.enhydra.jawe.components.graph.actions.SetTransitionMode;
import org.enhydra.shark.xpdl.XMLUtil;
import org.enhydra.shark.xpdl.elements.Activity;
import org.enhydra.shark.xpdl.elements.ActivitySet;
import org.enhydra.shark.xpdl.elements.Participant;
import org.enhydra.shark.xpdl.elements.Transition;

/**
 *  Container for displaying menubar, toolbar, process graphs ...
 *
 *  @author Sasa Bojanic
 */
public class GraphControllerPanel extends JPanel implements JaWEComponentView {

    protected GraphController controller;
    // various things needed for initializing and further work
    protected JScrollPane graphScrollPane;
    protected JToolBar toolbar;
    protected XMLElementChoiceButton showParticipantChoiceButton;
    protected XMLElementChoiceButton asChoiceButton;

    public GraphControllerPanel(GraphController controller) {
        this.controller = controller;
    }

    public void configure() {
    }

    public void init() {
        setBorder(BorderFactory.createEtchedBorder());
        setLayout(new BorderLayout());
        JPanel toolbars = new JPanel();
        toolbars.setLayout(new BorderLayout());
        // creating toolbars
        toolbar = BarFactory.createToolbar("defaultToolbar", controller);
        toolbar.setFloatable(false);
        // creating button panel
        ImageIcon curIc = controller.getGraphSettings().getParticipantsIcon();
        showParticipantChoiceButton = new XMLElementChoiceButton(Participant.class, controller, curIc, true, new String[]{"Id", "Name", "ParticipantType", "Description"});
        showParticipantChoiceButton.setToolTipText(controller.getSettings().getLanguageDependentString("InsertExistingParticipant" + BarFactory.TOOLTIP_POSTFIX));
        curIc = controller.getGraphSettings().getActivitySetSelectIcon();
        asChoiceButton = new XMLElementChoiceButton(ActivitySet.class, controller, curIc, true, new String[]{"Id"});
        asChoiceButton.setToolTipText(controller.getSettings().getLanguageDependentString("SelectActivitySet" + BarFactory.TOOLTIP_POSTFIX));
        JToolBar part = new JToolBar();


        if (controller.getGraphSettings().useParticipantChoiceButton()) {
            part.add(showParticipantChoiceButton);
        }

        if (controller.getGraphSettings().useActivitySetChoiceButton()) {
            part.add(asChoiceButton);
        }

        if (controller.getGraphSettings().useParticipantChoiceButton() || controller.getGraphSettings().useActivitySetChoiceButton()) {
            toolbar.addSeparator();
            toolbar.add(part);
        }
        // creating working component
        graphScrollPane = createWorkingComponent();

        JToolBar toolbox = createToolbox();
        toolbox.setOrientation(SwingConstants.HORIZONTAL);
        toolbars.add(toolbar, BorderLayout.NORTH);
        toolbars.add(toolbox, BorderLayout.CENTER);
        add(toolbars, BorderLayout.NORTH);
        add(graphScrollPane, BorderLayout.CENTER);
    }

    public JaWEComponent getJaWEComponent() {
        return controller;
    }

    public JComponent getDisplay() {
        return this;
    }

    protected JToolBar createToolbox() {
        String toolbarName = "toolbox";
        String actionOrder = controller.getSettings().getToolbarActionOrder(toolbarName);

        JaWETypes jts = JaWEManager.getInstance().getJaWEController().getJaWETypes();

        JToolBar toolbar = new JToolBar();
        toolbar.setRollover(true);
        String[] act = Utils.tokenize(actionOrder, BarFactory.ACTION_DELIMITER);

        for (int j = 0; j < act.length; j++) {
            if (act[j].equals(BarFactory.ACTION_SEPARATOR)) {
                toolbar.addSeparator();
            } else if (act[j].equals("SetSelectMode")) {
                JaWEAction ja = new JaWEAction();
                ja.setAction(new SetSelectMode(controller));
                ja.setIcon(((GraphSettings) controller.getSettings()).getSelectionIcon());
                ja.setLangDepName(controller.getSettings().getLanguageDependentString("SelectionKey"));
                JButton b = BarFactory.createToolbarButton(ja, controller);
                b.setToolTipText(ja.getLangDepName());
                toolbar.add(b);
                controller.getSettings().addAction("SetSelectMode", ja);
            } else if (act[j].equals("SetParticipantModeCommonExpression")) {
                JaWEAction ja = new JaWEAction();
                try {
                    String clsName = "org.enhydra.jawe.components.graph.actions.SetParticipantModeCommonExpression";
                    ActionBase action = (ActionBase) Class.forName(clsName).getConstructor(new Class[]{
                                GraphController.class
                            }).newInstance(new Object[]{
                                controller
                            });
                    ja.setAction(action);
                } catch (Exception ex) {
                }
                ja.setIcon(((GraphSettings) controller.getSettings()).getCommonExpresionParticipantIcon());
                ja.setLangDepName(controller.getSettings().getLanguageDependentString("CommonExpressionParticipantKey"));
                JButton b = BarFactory.createToolbarButton(ja, controller);
                b.setToolTipText(ja.getLangDepName());
                toolbar.add(b);
                controller.getSettings().addAction("SetParticipantModeCommonExpression", ja);
            } else if (act[j].equals("SetParticipantModeFreeTextExpression")) {
                JaWEAction ja = new JaWEAction();
                ja.setAction(new SetParticipantModeFreeTextExpression(controller));
                ja.setIcon(((GraphSettings) controller.getSettings()).getFreeTextParticipantIcon());
                ja.setLangDepName(controller.getSettings().getLanguageDependentString("FreeTextExpressionParticipantKey"));
                JButton b = BarFactory.createToolbarButton(ja, controller);
                b.setToolTipText(ja.getLangDepName());
                toolbar.add(b);
                controller.getSettings().addAction("SetParticipantModeFreeTextExpression", ja);
            } //CUSTOM
            else if (act[j].equals("SetStartMode")) {
                JaWEAction ja = new JaWEAction();
                ja.setAction(new SetStartMode(controller));
                ja.setIcon(((GraphSettings) controller.getSettings()).getBubbleStartIcon());
                ja.setLangDepName(controller.getSettings().getLanguageDependentString("StartBubbleKey"));
                JButton b = BarFactory.createToolbarButton(ja, controller);
                b.setToolTipText(ja.getLangDepName());
                toolbar.add(b);
                controller.getSettings().addAction("SetStartMode", ja);
            } else if (act[j].equals("SetEndMode")) {
                JaWEAction ja = new JaWEAction();
                ja.setAction(new SetEndMode(controller));
                ja.setIcon(((GraphSettings) controller.getSettings()).getBubbleEndIcon());
                ja.setLangDepName(controller.getSettings().getLanguageDependentString("EndBubbleKey"));
                JButton b = BarFactory.createToolbarButton(ja, controller);
                b.setToolTipText(ja.getLangDepName());
                toolbar.add(b);
                controller.getSettings().addAction("SetEndMode", ja);
                //END CUSTOM
            } else if (act[j].startsWith("SetParticipantMode")) {
                String type = act[j].substring("SetParticipantMode".length());
                if (type.equals("*")) {
                    List parTypes = jts.getTypes(Participant.class);
                    for (int i = 0; i < parTypes.size(); i++) {
                        JaWEType jt = (JaWEType) parTypes.get(i);
                        JaWEAction ja = new JaWEAction();
                        ja.setAction(new SetParticipantMode(controller, jt.getTypeId()));
                        ja.setIcon(jt.getIcon());
                        ja.setLangDepName(jt.getDisplayName());
                        JButton b = BarFactory.createToolbarButton(ja, controller);
                        b.setToolTipText(ja.getLangDepName());
                        toolbar.add(b);
                        controller.getSettings().addAction(jt.getTypeId(), ja);
                    }
                } else if (!(type.equals("SetParticipantModeCommonExpression") || type.equals("SetParticipantModeFreeTextExpression"))) {
                    JaWEType jt = jts.getType(type);
                    if (jt == null) {
                        continue;
                    }
                    JaWEAction ja = new JaWEAction();
                    ja.setAction(new SetParticipantMode(controller, jt.getTypeId()));
                    ja.setIcon(jt.getIcon());
                    ja.setLangDepName(jt.getDisplayName());
                    JButton b = BarFactory.createToolbarButton(ja, controller);
                    b.setToolTipText(ja.getLangDepName());
                    toolbar.add(b);
                    controller.getSettings().addAction(jt.getTypeId(), ja);
                }
            } else if (act[j].startsWith("SetActivityMode")) {
                String type = act[j].substring("SetActivityMode".length());
                if (type.equals("*")) {
                    List actTypes = jts.getTypes(Activity.class);
                    for (int i = 0; i < actTypes.size(); i++) {
                        JaWEType jt = (JaWEType) actTypes.get(i);
                        JaWEAction ja = new JaWEAction();
                        ja.setAction(new SetActivityMode(controller, jt.getTypeId()));
                        ja.setIcon(jt.getIcon());
                        ja.setLangDepName(jt.getDisplayName());
                        JButton b = BarFactory.createToolbarButton(ja, controller);
                        b.setToolTipText(ja.getLangDepName());
                        toolbar.add(b);
                        controller.getSettings().addAction(jt.getTypeId(), ja);
                    }
                } else {
                    JaWEType jt = jts.getType(type);
                    if (jt == null) {
                        continue;
                    }
                    JaWEAction ja = new JaWEAction();
                    ja.setAction(new SetActivityMode(controller, jt.getTypeId()));
                    ja.setIcon(jt.getIcon());
                    ja.setLangDepName(jt.getDisplayName());
                    JButton b = BarFactory.createToolbarButton(ja, controller);
                    b.setToolTipText(ja.getLangDepName());
                    toolbar.add(b);
                    controller.getSettings().addAction(jt.getTypeId(), ja);
                }
            } else if (act[j].startsWith("SetTransitionMode")) {
                String type = act[j].substring("SetTransitionMode".length());
                if (type.equals("*")) {
                    List traTypes = jts.getTypes(Transition.class);
                    for (int i = 0; i < traTypes.size(); i++) {
                        JaWEType jt = (JaWEType) traTypes.get(i);
                        JaWEAction ja = new JaWEAction();
                        ja.setAction(new SetTransitionMode(controller, jt.getTypeId()));
                        ja.setIcon(jt.getIcon());
                        ja.setLangDepName(jt.getDisplayName());
                        JButton b = BarFactory.createToolbarButton(ja, controller);
                        b.setToolTipText(ja.getLangDepName());
                        toolbar.add(b);
                        controller.getSettings().addAction(jt.getTypeId(), ja);
                    }
                } else {
                    JaWEType jt = jts.getType(type);
                    if (jt == null) {
                        continue;
                    }
                    JaWEAction ja = new JaWEAction();
                    ja.setAction(new SetTransitionMode(controller, jt.getTypeId()));
                    ja.setIcon(jt.getIcon());
                    ja.setLangDepName(jt.getDisplayName());
                    JButton b = BarFactory.createToolbarButton(ja, controller);
                    b.setToolTipText(ja.getLangDepName());
                    toolbar.add(b);
                    controller.getSettings().addAction(jt.getTypeId(), ja);
                }
            }
        }

        toolbar.setName(controller.getSettings().getLanguageDependentString(toolbarName + BarFactory.LABEL_POSTFIX));

        return toolbar;

    }

    protected JScrollPane createWorkingComponent() {
        JScrollPane lGraphScrollPane = new JScrollPane();
        JViewport port = lGraphScrollPane.getViewport();
        port.setScrollMode(JViewport.BLIT_SCROLL_MODE);

        // Harald Meister: set bigger scroll-amounts, especially useful for
        // mouse-wheel-scolling in large workflows
        lGraphScrollPane.getVerticalScrollBar().setUnitIncrement(20);
        lGraphScrollPane.getHorizontalScrollBar().setUnitIncrement(40);

        return lGraphScrollPane;
    }

    public void graphSelected(Graph graph) {
        graphScrollPane.setViewportView(graph);
    }

    public void enableDisableButtons() {
        if (controller.getSelectedGraph() != null) {
            if (XMLUtil.getPackage(controller.getSelectedGraph().getXPDLObject()) == JaWEManager.getInstance().getJaWEController().getMainPackage()) {
                if (controller.getChoices(showParticipantChoiceButton).size() != 0) {
                    showParticipantChoiceButton.setEnabled(true);
                } else {
                    showParticipantChoiceButton.setEnabled(false);
                }
            } else {
                showParticipantChoiceButton.setEnabled(false);
            }
        } else {
            showParticipantChoiceButton.setEnabled(false);
        }

        if (controller.getChoices(asChoiceButton).size() != 0) {
            asChoiceButton.setEnabled(true);
        } else {
            asChoiceButton.setEnabled(false);
        }
    }
}
