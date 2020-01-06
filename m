Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 631EC130C39
	for <lists+linux-fscrypt@lfdr.de>; Mon,  6 Jan 2020 03:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbgAFCzM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 5 Jan 2020 21:55:12 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:59582 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727307AbgAFCzM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 5 Jan 2020 21:55:12 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=eguan@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Tmv.V2J_1578279309;
Received: from localhost(mailfrom:eguan@linux.alibaba.com fp:SMTPD_---0Tmv.V2J_1578279309)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 06 Jan 2020 10:55:09 +0800
Date:   Mon, 6 Jan 2020 10:55:09 +0800
From:   Eryu Guan <eguan@linux.alibaba.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: Re: [PATCH v2 0/5] xfstests: verify ciphertext of IV_INO_LBLK_64
 encryption policies
Message-ID: <20200106025509.GF41863@e18g06458.et15sqa>
References: <20191202230155.99071-1-ebiggers@kernel.org>
 <20191209181826.GC149190@gmail.com>
 <20200103164626.GA19521@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103164626.GA19521@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jan 03, 2020 at 08:46:26AM -0800, Eric Biggers wrote:
> On Mon, Dec 09, 2019 at 10:18:27AM -0800, Eric Biggers wrote:
> > On Mon, Dec 02, 2019 at 03:01:50PM -0800, Eric Biggers wrote:
> > > Hello,
> > > 
> > > This series adds an xfstest which tests that the encryption for
> > > IV_INO_LBLK_64 encryption policies is being done correctly.
> > > 
> > > IV_INO_LBLK_64 is a new fscrypt policy flag which modifies the
> > > encryption to be optimized for inline encryption hardware compliant with
> > > the UFS v2.1 standard or the upcoming version of the eMMC standard.  For
> > > more information, see the kernel patchset:
> > > https://lore.kernel.org/linux-fscrypt/20191024215438.138489-1-ebiggers@kernel.org/T/#u
> > > 
> > > The kernel patches have been merged into mainline and will be in v5.5.
> > > 
> > > In addition to the latest kernel, to run on ext4 this test also needs a
> > > version of e2fsprogs built from the master branch, in order to get
> > > support for formatting the filesystem with '-O stable_inodes'.
> > > 
> > > As usual, the test will skip itself if the prerequisites aren't met.
> > > 
> > > No real changes since v1; just rebased onto the latest xfstests master
> > > branch and updated the cover letter.
> > > 
> > > Eric Biggers (5):
> > >   fscrypt-crypt-util: create key_and_iv_params structure
> > >   fscrypt-crypt-util: add HKDF context constants
> > >   common/encrypt: create named variables for UAPI constants
> > >   common/encrypt: support verifying ciphertext of IV_INO_LBLK_64
> > >     policies
> > >   generic: verify ciphertext of IV_INO_LBLK_64 encryption policies
> > > 
> > >  common/encrypt           | 126 +++++++++++++++++++++++++-------
> > >  src/fscrypt-crypt-util.c | 151 ++++++++++++++++++++++++++++-----------
> > >  tests/generic/805        |  43 +++++++++++
> > >  tests/generic/805.out    |   6 ++
> > >  tests/generic/group      |   1 +
> > >  5 files changed, 259 insertions(+), 68 deletions(-)
> > >  create mode 100644 tests/generic/805
> > >  create mode 100644 tests/generic/805.out
> > > 
> > 
> > Ping.  Does anyone want to take a look at this?  Satya?
> > 
> 
> Eryu, can you review and consider applying this series?  It doesn't look like
> anyone else is going to formally review it.

I've reviewed & applied this patchset in my local tree, will push them
out soon. So sorry for the delay!

Thanks,
Eryu
