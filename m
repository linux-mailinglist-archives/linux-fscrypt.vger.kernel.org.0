Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75A922F5A5
	for <lists+linux-fscrypt@lfdr.de>; Mon, 27 Jul 2020 18:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgG0Qp5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 27 Jul 2020 12:45:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgG0Qp4 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 27 Jul 2020 12:45:56 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7233820729;
        Mon, 27 Jul 2020 16:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595868356;
        bh=TLTpq4BfZYUs7u+AbSrPyF6ds+86udPLJwaM3gj5D7M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T4w/rVDFm+hGeC/BjmlFZamuSTjVAfHTVjK2MdF3x4SfbOiypkXeQuw9HrPB8ReE1
         91O2n5DYJwtVudTrp5zXZc74AW1EUZhB2XkXReG70qlh528HZmf5RyaDXWlM+6K6E2
         jqmkKfj2/eaX9T1uES9LX21W8rwLarVizv+TWgEk=
Date:   Mon, 27 Jul 2020 09:45:55 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 0/4] e2fsprogs: fix and document the stable_inodes feature
Message-ID: <20200727164555.GF1138@sol.localdomain>
References: <20200401203239.163679-1-ebiggers@kernel.org>
 <20200410152406.GO45598@mit.edu>
 <20200507181847.GD236103@gmail.com>
 <20200615222240.GD85413@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615222240.GD85413@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jun 15, 2020 at 03:22:40PM -0700, Eric Biggers wrote:
> On Thu, May 07, 2020 at 11:18:47AM -0700, Eric Biggers wrote:
> > On Fri, Apr 10, 2020 at 11:24:06AM -0400, Theodore Y. Ts'o wrote:
> > > On Wed, Apr 01, 2020 at 01:32:35PM -0700, Eric Biggers wrote:
> > > > Fix tune2fs to not allow cases where IV_INO_LBLK_64-encrypted files
> > > > (which can exist if the stable_inodes feature is set) could be broken:
> > > > 
> > > > - Changing the filesystem's UUID
> > > > - Clearing the stable_inodes feature
> > > > 
> > > > Also document the stable_inodes feature in the appropriate places.
> > > > 
> > > > Eric Biggers (4):
> > > >   tune2fs: prevent changing UUID of fs with stable_inodes feature
> > > >   tune2fs: prevent stable_inodes feature from being cleared
> > > >   ext4.5: document the stable_inodes feature
> > > >   tune2fs.8: document the stable_inodes feature
> > > 
> > > Thanks, I've applied this patch series.
> > > 
> > 
> > Ted, I still don't see this in git.  Are you planning to push it out?

Ping?
