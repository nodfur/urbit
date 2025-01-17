import React, { useCallback, useEffect, useMemo } from 'react';
import { RouteComponentProps } from 'react-router-dom';
import fuzzy from 'fuzzy';
import { Treaty } from '@urbit/api';
import { ShipName } from '../../components/ShipName';
import useDocketState, { useAllyTreaties } from '../../state/docket';
import { useLeapStore } from '../Nav';
import { AppList } from '../../components/AppList';
import { addRecentDev } from './Home';

type AppsProps = RouteComponentProps<{ ship: string }>;

export const Apps = ({ match }: AppsProps) => {
  const { searchInput, selectedMatch, select } = useLeapStore((state) => ({
    searchInput: state.searchInput,
    select: state.select,
    selectedMatch: state.selectedMatch
  }));
  const provider = match?.params.ship;
  const treaties = useAllyTreaties(provider);
  const results = useMemo(() => {
    if (!treaties) {
      return undefined;
    }
    const values = Object.values(treaties);
    return fuzzy
      .filter(
        searchInput,
        values.map((v) => v.title)
      )
      .sort((a, b) => {
        const left = a.string.startsWith(searchInput) ? a.score + 1 : a.score;
        const right = b.string.startsWith(searchInput) ? b.score + 1 : b.score;

        return right - left;
      })
      .map((result) => values[result.index]);
  }, [treaties, searchInput]);
  const count = results?.length;

  const getAppPath = useCallback(
    (app: Treaty) => `${match?.path.replace(':ship', provider)}/${app.ship}/${app.desk}`,
    [match]
  );

  useEffect(() => {
    const { fetchAllyTreaties } = useDocketState.getState();
    fetchAllyTreaties(provider);
    select(
      <>
        Apps by <ShipName name={provider} className="font-mono" />
      </>
    );
  }, [provider]);

  useEffect(() => {
    if (results) {
      useLeapStore.setState({
        matches: results.map((r) => ({
          url: getAppPath(r),
          openInNewTab: false,
          value: r.desk,
          display: r.title
        }))
      });
    }
  }, [results]);

  useEffect(() => {
    if (provider) {
      useDocketState.getState().fetchAllyTreaties(provider);
      addRecentDev(provider);
    }
  }, [provider]);

  return (
    <div className="dialog-inner-container md:px-6 md:py-8 h4 text-gray-400">
      <div id="developed-by">
        <h2 className="mb-3">
          Software developed by <ShipName name={provider} className="font-mono" />
        </h2>
        <p>
          {count} result{count === 1 ? '' : 's'}
        </p>
      </div>
      {results && (
        <AppList
          apps={results}
          labelledBy="developed-by"
          matchAgainst={selectedMatch}
          to={getAppPath}
        />
      )}
      <p>That&apos;s it!</p>
    </div>
  );
};
