Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2787310BE65
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 Nov 2019 22:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbfK0Uq1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 27 Nov 2019 15:46:27 -0500
Received: from mga04.intel.com ([192.55.52.120]:12027 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729870AbfK0Uq1 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 27 Nov 2019 15:46:27 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 12:46:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="211870610"
Received: from gtau-mobl.ger.corp.intel.com (HELO localhost) ([10.251.83.243])
  by orsmga006.jf.intel.com with ESMTP; 27 Nov 2019 12:46:24 -0800
Date:   Wed, 27 Nov 2019 22:46:22 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] xfstests: test adding filesystem-level fscrypt
 key via key_id
Message-ID: <20191127204622.GB12520@linux.intel.com>
References: <20191119223130.228341-1-ebiggers@kernel.org>
 <20191127204536.GA12520@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127204536.GA12520@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 27, 2019 at 10:45:36PM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 19, 2019 at 02:31:27PM -0800, Eric Biggers wrote:
> > This series adds a test which tests adding a key to a filesystem's
> > fscrypt keyring via an "fscrypt-provisioning" keyring key.  This is an
> > alternative to the normal method where the raw key is given directly.
> > 
> > I'm sending this out for comment, but it shouldn't be merged until the
> > corresponding kernel patch has reached mainline.  For more details, see
> > the kernel patch:
> > https://lkml.kernel.org/linux-fscrypt/20191119222447.226853-1-ebiggers@kernel.org/T/#u
> > 
> > This test depends on an xfs_io patch which adds the '-k' option to the
> > 'add_enckey' command, e.g.:
> > 
> > 	xfs_io -c "add_enckey -k KEY_ID" MOUNTPOINT
> > 
> > This test is skipped if the needed kernel or xfs_io support is absent.
> > 
> > This has been tested on ext4, f2fs, and ubifs.
> > 
> > To apply cleanly, my other xfstests patch series
> > "[RFC PATCH 0/5] xfstests: verify ciphertext of IV_INO_LBLK_64 encryption policies"
> > must be applied first.
> > 
> > This series can also be retrieved from
> > https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git
> > tag "fscrypt-provisioning_2019-11-19".
> > 
> > Eric Biggers (3):
> >   common/rc: handle option with argument in _require_xfs_io_command()
> >   common/encrypt: move constant test key to common code
> >   generic: test adding filesystem-level fscrypt key via key_id
> > 
> >  common/encrypt        |  95 +++++++++++++++++++++----
> >  common/rc             |   2 +-
> >  tests/generic/580     |  17 ++---
> >  tests/generic/806     | 156 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/806.out |  73 ++++++++++++++++++++
> >  tests/generic/group   |   1 +
> >  6 files changed, 316 insertions(+), 28 deletions(-)
> >  create mode 100644 tests/generic/806
> >  create mode 100644 tests/generic/806.out
> > 
> > -- 
> > 2.24.0.432.g9d3f5f5b63-goog
> > 
> 
> I'm newbie with fscrypt so I started by encrypting a directory without
> the new feature
> 
> sudo tune2fs -O encrypt /dev/sda2
> sudo fscrypt setup /
> fscrypt encrypt foo
> 
> Worked.
> 
> Generally speaking I'd appreciate a usage example like here to the
> commit message:
> 
> https://lwn.net/Articles/692514/
> 
> Is this doable?
> 
> I might consider trying out the XFS test suite some day but right now it
> would be first nice to smoke test the feature quickly.
> 
> I think for this patch that would actually be mostly sufficient testing.

Sorry, this was meant for the kernel patch :-/

/Jarkko
