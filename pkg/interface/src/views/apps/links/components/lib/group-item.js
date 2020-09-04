import React, { Component } from 'react';
import { ChannelItem } from './channel-item';

export const GroupItem = (props) => {
  const association = props.association ? props.association : {};

  let title =
    association['app-path'] ? association['app-path'] : 'Unmanaged Collections';

  if (association.metadata && association.metadata.title) {
    title = association.metadata.title !== ''
      ? association.metadata.title : title;
  }

  const channels = props.channels ? props.channels : [];
  const first = (props.index === 0) ? 'pt1' : 'pt6';

  const channelItems = channels.map((each, i) => {
    const meta = props.linkMetadata[each];
    if (!meta) { return null; }
    const selected = (props.selected === each);
    return (
      <ChannelsItem
        key={each}
        link={each}
        selected={selected}
        name={meta.metadata.title}
      />
    );
  });

  return (
    <div className={first}>
      <p className="f9 ph4 pb2 gray3">{title}</p>
      {channelItems}
    </div>
  );
};

