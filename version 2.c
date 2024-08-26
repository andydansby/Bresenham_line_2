
        void bresenham_clean(int xx1, int yy1, int xx2, int yy2)
        {
            /// idea behind this is that theres only a finite number of pixels
            /// which should be a the MAX between delta_x1 or delta_y1
            /// 

            int pixel_sum = 0;
            int iterations = 0;
            int pass = 1;
            int delta_y1;
            int delta_x1;

            int deltaX;
            int deltaY;

            int stepx;
            int stepy;
            int fraction;

            delta_x1 = xx2 - xx1;
            delta_y1 = yy2 - yy1;

            stepx = (delta_x1 < 0) ? -1 : 1;
            stepy = (delta_y1 < 0) ? -1 : 1;

            deltaX = Math.Abs(delta_x1);
            deltaY = Math.Abs(delta_y1);

            pixel_sum = Math.Max(deltaX, deltaY);

            //plot starting point
            //buffer_plotX = xx1;
            //buffer_plotY = yy1;
            //buffer_plot();

            if (deltaX > deltaY)
            {
                fraction = deltaY - (deltaX >> 1);// multiply by 2

                for (iterations = 0; iterations < pixel_sum; iterations++)
                {
                    //buffer_plotX = xx1;
                    //buffer_plotY = yy1;
                    //buffer_plot(); 
                    //buffer_point();

                    if (fraction >= 0)
                    {
                        yy1 += stepy;
                        fraction -= deltaX;
                    }
                    xx1 += stepx;
                    fraction += deltaY;
                    pass++;

                    if (pass > pixel_sum)
                    {
                        break;
                    }
                }//end for loop
            }//end if
            else       //(deltaX <= deltaY)     (deltaY >= deltaX)
            {
                fraction = deltaX - (deltaY >> 1);

                for (iterations = 0; iterations < pixel_sum; iterations++)
                {
                    //buffer_plotX = xx1;
                    //buffer_plotY = yy1;
                    //buffer_plot();
                    //buffer_point();

                    if (fraction >= 0)
                    {
                        xx1 += stepx;
                        fraction -= deltaY;
                    }
                    yy1 += stepy;
                    fraction += deltaX;
                    pass++;

                    if (pass > pixel_sum)
                    {
                        break;
                    }
                }//end for loop
            }//end else
        }//end routine


