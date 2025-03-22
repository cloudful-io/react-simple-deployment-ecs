import * as React from 'react';
import AppBar from '@mui/material/AppBar';
import Box from '@mui/material/Box';
import Divider from '@mui/material/Divider';
import Drawer from '@mui/material/Drawer';
import IconButton from '@mui/material/IconButton';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemText from '@mui/material/ListItemText';
import MenuIcon from '@mui/icons-material/Menu';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import HomeIcon from '@mui/icons-material/Home';


const drawerWidth = 240;

const navItems = [
    ['Page 1', '/#/page1'],
    ['Page 2', '/#/page2'],
    ['Page 3', '/#/page3']
  ];

function ResponsiveAppNavbar(props) {
  const { window } = props;
  const [mobileOpen, setMobileOpen] = React.useState(false);

  const handleDrawerToggle = () => {
    setMobileOpen((prevState) => !prevState);
  };

  const drawer = (
    <Box onClick={handleDrawerToggle} sx={{ textAlign: 'center' }}>
        <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 1, my: 2 }}>
            <HomeIcon/>
            <Typography variant="h6" sx={{ my: 2, lineHeight: 1 }}>
                {process.env.REACT_APP_SITE_TITLE}
            </Typography>
         </Box>
      <Divider />
      <List>
        {navItems.map(([label, link]) => (
          <ListItem key={label} disablePadding>
            <ListItemButton sx={{ textAlign: 'center' }} component="a" href={link}>
              <ListItemText primary={label} />
            </ListItemButton>
          </ListItem>
        ))}
      </List>
    </Box>
  );

  const container = window !== undefined ? () => window().document.body : undefined;

  return (
    <>
      <AppBar component="nav">
        <Toolbar>
          <IconButton
            color="inherit"
            aria-label="open drawer"
            edge="start"
            onClick={handleDrawerToggle}
            sx={{ mr: 2, display: { sm: 'none'} }}
          >
            <MenuIcon />
          </IconButton>
          <Box
            component="a"
            color="inherit"
            sx={{ position: 'absolute', left: '50%', transform: 'translateX(-50%)', textDecoration: 'none', textAlign: 'center', display: { sm: 'none' } }}
            href="/">
            <Typography
                variant="h6"
                component="div"
                sx={{ flexGrow: 1, textAlign: 'center', display: { sm: 'none' } }}
            >
                {process.env.REACT_APP_SITE_TITLE}
              </Typography>
          </Box>
          <Box
            component="a"
            color="inherit"
            sx={{ textDecoration: 'none', display: 'flex', alignItems: 'center', width: 'auto' }}
            href="/">
            <HomeIcon sx={{display: { xs: 'none', sm: 'block'}}}/>
            <Typography
              variant="h6"
              component="div"
              paddingLeft={1}
              sx={{ flexGrow: 1, display: { xs: 'none', sm: 'block' } }}
            >
              {process.env.REACT_APP_SITE_TITLE}

            </Typography>
          </Box>
          
          <Box sx={{ display: { xs: 'none', sm: 'block' }, marginLeft: 'auto' }}>
            {navItems.map(([label, link]) => (
              <Button key={label} color="inherit" component="a" href={link}>
                {label}
              </Button>
            ))}
          </Box>
        </Toolbar>
      </AppBar>
      <nav>
        <Drawer
          container={container}
          variant="temporary"
          open={mobileOpen}
          onClose={handleDrawerToggle}
          ModalProps={{
            keepMounted: true, // Better open performance on mobile.
          }}
          sx={{
            display: { xs: 'block', sm: 'none' },
            '& .MuiDrawer-paper': { boxSizing: 'border-box', width: drawerWidth },
          }}
        >
          {drawer}
        </Drawer>
      </nav>
      </>
    )  
};

export default ResponsiveAppNavbar;