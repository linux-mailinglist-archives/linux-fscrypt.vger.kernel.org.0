Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400922597D5
	for <lists+linux-fscrypt@lfdr.de>; Tue,  1 Sep 2020 18:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgIAQTz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 1 Sep 2020 12:19:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbgIAQTp (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 1 Sep 2020 12:19:45 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 720D32065F;
        Tue,  1 Sep 2020 16:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598977185;
        bh=5fmv3liAy2AA2zgQtwuQUk/DiRgWN0KqifzEK4zr+cY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kK8k1jG55cZ/1Vf0304O9BkuyvSq/ZrmpTTlJvvpNap7P0ezzzfKPJTEemKuoWOmm
         BlqkokSMnN7bTbceqls+ugRY73EeInvcZE0cW6A54DKnFufrVSDatA2T2a5rjkPjLw
         go2Rg5c2t5EMIBrvfrXuYY6YA8n64tUNgugXtQtA=
Date:   Tue, 1 Sep 2020 09:19:44 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 0/4] e2fsprogs: fix and document the stable_inodes feature
Message-ID: <20200901161944.GC669796@gmail.com>
References: <20200401203239.163679-1-ebiggers@kernel.org>
 <20200410152406.GO45598@mit.edu>
 <20200507181847.GD236103@gmail.com>
 <20200615222240.GD85413@gmail.com>
 <20200727164555.GF1138@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727164555.GF1138@sol.localdomain>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jul 27, 2020 at 09:45:55AM -0700, Eric Biggers wrote:
> On Mon, Jun 15, 2020 at 03:22:40PM -0700, Eric Biggers wrote:
> > On Thu, May 07, 2020 at 11:18:47AM -0700, Eric Biggers wrote:
> > > On Fri, Apr 10, 2020 at 11:24:06AM -0400, Theodore Y. Ts'o wrote:
> > > > On Wed, Apr 01, 2020 at 01:32:35PM -0700, Eric Biggers wrote:
> > > > > Fix tune2fs to not allow cases where IV_INO_LBLK_64-encrypted files
> > > > > (which can exist if the stable_inodes feature is set) could be broken:
> > > > > 
> > > > > - Changing the filesystem's UUID
> > > > > - Clearing the stable_inodes feature
> > > > > 
> > > > > Also document the stable_inodes feature in the appropriate places.
> > > > > 
> > > > > Eric Biggers (4):
> > > > >   tune2fs: prevent changing UUID of fs with stable_inodes feature
> > > > >   tune2fs: prevent stable_inodes feature from being cleared
> > > > >   ext4.5: document the stable_inodes feature
> > > > >   tune2fs.8: document the stable_inodes feature
> > > > 
> > > > Thanks, I've applied this patch series.
> > > > 
> > > 
> > > Ted, I still don't see this in git.  Are you planning to push it out?
> 
> Ping?

Ping.
