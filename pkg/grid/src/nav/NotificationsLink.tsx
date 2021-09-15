import classNames from 'classnames';
import React from 'react';
import { Link, LinkProps } from 'react-router-dom';
import { Bullet } from '../components/icons/Bullet';
import { Notification } from '../state/hark-types';
import { useNotifications } from '../state/notifications';

type NotificationsState = 'empty' | 'unread' | 'attention-needed';

function getNotificationsState(
  notifications: Notification[],
  systemNotifications: Notification[]
): NotificationsState {
  if (systemNotifications.length > 0) {
    return 'attention-needed';
  }

  // TODO: when real structure, this should be actually be unread not just existence
  if (notifications.length > 0) {
    return 'unread';
  }

  return 'empty';
}

type NotificationsLinkProps = Omit<LinkProps<HTMLAnchorElement>, 'to'> & {
  navOpen: boolean;
  shouldDim: boolean;
};

export const NotificationsLink = ({ navOpen, shouldDim }: NotificationsLinkProps) => {
  const { notifications, systemNotifications } = useNotifications();
  const state = getNotificationsState(notifications, systemNotifications);

  return (
    <Link
      to="/leap/notifications"
      className={classNames(
        'relative z-50 flex-none circle-button h4 default-ring',
        navOpen && 'text-opacity-60',
        shouldDim && 'opacity-60',
        state === 'empty' && !navOpen && 'text-gray-400 bg-gray-50',
        state === 'empty' && navOpen && 'text-gray-400 bg-white',
        state === 'unread' && 'bg-blue-400 text-white',
        state === 'attention-needed' && 'text-white bg-orange-400'
      )}
    >
      {state === 'empty' && <Bullet className="w-6 h-6" />}
      {state === 'unread' && notifications.length}
      {state === 'attention-needed' && (
        <span className="h2">
          ! <span className="sr-only">Attention needed</span>
        </span>
      )}
    </Link>
  );
};