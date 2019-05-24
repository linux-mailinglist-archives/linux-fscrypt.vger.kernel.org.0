Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67DFE29C89
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 May 2019 18:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390346AbfEXQwj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 May 2019 12:52:39 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56740 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390210AbfEXQwj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 May 2019 12:52:39 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x4OGqDtZ028397
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 May 2019 12:52:16 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 421D9420481; Fri, 24 May 2019 12:52:13 -0400 (EDT)
Date:   Fri, 24 May 2019 12:52:13 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Sahitya Tummala <stummala@codeaurora.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Roman Gushchin <guro@fb.com>,
        Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan.c: drop all inode/dentry cache from LRU
Message-ID: <20190524165213.GB2765@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        Sahitya Tummala <stummala@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>, Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Yafang Shao <laoar.shao@gmail.com>, Roman Gushchin <guro@fb.com>,
        Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1558685161-860-1-git-send-email-stummala@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558685161-860-1-git-send-email-stummala@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, May 24, 2019 at 01:36:01PM +0530, Sahitya Tummala wrote:
> This is important for the scenario where FBE (file based encryption)
> is enabled. With FBE, the encryption context needed to en/decrypt a file
> will be stored in inode and any inode that is left in the cache after
> drop_caches is done will be a problem. For ex, in Android, drop_caches
> will be used when switching work profiles.
> 
> Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>

Instead of making a change to vmscan.c, it's probably better to
migrate to the new fscrypt key-management framework, which solves this
problem with an explicit FS_IOC_REMOVE_ENCRYPTION_KEY ioctl.  This
allows the system to remove all inodes that were made available via a
single key without having nuking all other inodes --- this would make
it much faster after a user logs out of ChromeOS, for example:

See:

	https://patchwork.kernel.org/patch/10952019/

							- Ted
