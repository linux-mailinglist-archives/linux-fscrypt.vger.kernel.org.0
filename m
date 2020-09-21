Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF3E2735E2
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Sep 2020 00:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbgIUWla (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Sep 2020 18:41:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726644AbgIUWl3 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Sep 2020 18:41:29 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8389123A1B;
        Mon, 21 Sep 2020 22:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600728089;
        bh=x08HFAO6Wn3VSVtWdPKsga7xcSFqWU1qfEvZkqWR1ms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gdv+DQ6pfYXS0sS5yhxsvdxJGjHCBSxRhKFwCYFmckaF7HdqiZP8JcIg9JEcsSQSF
         J9JahC61bYtpcGaN0w34eojdC1+/f4Sp2tSenBdQrMvnxB+PnnZzs/LEjwhEr9b7Yz
         9pjELvccd8f3fNskXpC73xKo8R+RhLanzIM8vHtE=
Date:   Mon, 21 Sep 2020 15:41:28 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 0/4] e2fsprogs: fix and document the stable_inodes feature
Message-ID: <20200921224128.GE844@sol.localdomain>
References: <20200401203239.163679-1-ebiggers@kernel.org>
 <20200410152406.GO45598@mit.edu>
 <20200507181847.GD236103@gmail.com>
 <20200615222240.GD85413@gmail.com>
 <20200727164555.GF1138@sol.localdomain>
 <20200901161944.GC669796@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901161944.GC669796@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Sep 01, 2020 at 09:19:45AM -0700, Eric Biggers wrote:
> On Mon, Jul 27, 2020 at 09:45:55AM -0700, Eric Biggers wrote:
> > On Mon, Jun 15, 2020 at 03:22:40PM -0700, Eric Biggers wrote:
> > > On Thu, May 07, 2020 at 11:18:47AM -0700, Eric Biggers wrote:
> > > > On Fri, Apr 10, 2020 at 11:24:06AM -0400, Theodore Y. Ts'o wrote:
> > > > > On Wed, Apr 01, 2020 at 01:32:35PM -0700, Eric Biggers wrote:
> > > > > > Fix tune2fs to not allow cases where IV_INO_LBLK_64-encrypted files
> > > > > > (which can exist if the stable_inodes feature is set) could be broken:
> > > > > > 
> > > > > > - Changing the filesystem's UUID
> > > > > > - Clearing the stable_inodes feature
> > > > > > 
> > > > > > Also document the stable_inodes feature in the appropriate places.
> > > > > > 
> > > > > > Eric Biggers (4):
> > > > > >   tune2fs: prevent changing UUID of fs with stable_inodes feature
> > > > > >   tune2fs: prevent stable_inodes feature from being cleared
> > > > > >   ext4.5: document the stable_inodes feature
> > > > > >   tune2fs.8: document the stable_inodes feature
> > > > > 
> > > > > Thanks, I've applied this patch series.
> > > > > 
> > > > 
> > > > Ted, I still don't see this in git.  Are you planning to push it out?
> > 
> > Ping?
> 
> Ping.

Ping.
