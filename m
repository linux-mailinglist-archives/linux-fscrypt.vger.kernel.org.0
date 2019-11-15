Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD09FE3F5
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Nov 2019 18:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfKOR3x (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Nov 2019 12:29:53 -0500
Received: from mga04.intel.com ([192.55.52.120]:14118 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbfKOR3x (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Nov 2019 12:29:53 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Nov 2019 09:29:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,308,1569308400"; 
   d="scan'208";a="288613668"
Received: from sgaffney-mobl3.amr.corp.intel.com (HELO localhost) ([10.252.4.81])
  by orsmga001.jf.intel.com with ESMTP; 15 Nov 2019 09:29:45 -0800
Date:   Fri, 15 Nov 2019 19:29:44 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, "Theodore Y . Ts'o" <tytso@mit.edu>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Paul Lawrence <paullawrence@google.com>,
        linux-mtd@lists.infradead.org, Ondrej Kozina <okozina@redhat.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>, g@linux.intel.com
Subject: Re: [PATCH] fscrypt: support passing a keyring key to
 FS_IOC_ADD_ENCRYPTION_KEY
Message-ID: <20191115172944.GB21300@linux.intel.com>
References: <20191107001259.115018-1-ebiggers@kernel.org>
 <20191113203550.GI221701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113203550.GI221701@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 13, 2019 at 12:35:51PM -0800, Eric Biggers wrote:
> On Wed, Nov 06, 2019 at 04:12:59PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Extend the FS_IOC_ADD_ENCRYPTION_KEY ioctl to allow the raw key to be
> > specified by a Linux keyring key, rather than specified directly.
> > 
> > This is useful because fscrypt keys belong to a particular filesystem
> > instance, so they are destroyed when that filesystem is unmounted.
> > Usually this is desired.  But in some cases, userspace may need to
> > unmount and re-mount the filesystem while keeping the keys, e.g. during
> > a system update.  This requires keeping the keys somewhere else too.
> > 
> > The keys could be kept in memory in a userspace daemon.  But depending
> > on the security architecture and assumptions, it can be preferable to
> > keep them only in kernel memory, where they are unreadable by userspace.
> > 
> > We also can't solve this by going back to the original fscrypt API
> > (where for each file, the master key was looked up in the process's
> > keyring hierarchy) because that caused lots of problems of its own.
> > 
> > Therefore, add the ability for FS_IOC_ADD_ENCRYPTION_KEY to accept a
> > Linux keyring key.  This solves the problem by allowing userspace to (if
> > needed) save the keys securely in a Linux keyring for re-provisioning,
> > while still using the new fscrypt key management ioctls.
> > 
> > This is analogous to how dm-crypt accepts a Linux keyring key, but the
> > key is then stored internally in the dm-crypt data structures rather
> > than being looked up again each time the dm-crypt device is accessed.
> > 
> > Use a custom key type "fscrypt-provisioning" rather than one of the
> > existing key types such as "logon".  This is strongly desired because it
> > enforces that these keys are only usable for a particular purpose: for
> > fscrypt as input to a particular KDF.  Otherwise, the keys could also be
> > passed to any kernel API that accepts a "logon" key with any service
> > prefix, e.g. dm-crypt, UBIFS, or (recently proposed) AF_ALG.  This would
> > risk leaking information about the raw key despite it ostensibly being
> > unreadable.  Of course, this mistake has already been made for multiple
> > kernel APIs; but since this is a new API, let's do it right.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> David and Jarkko, are you okay with this patch from a keyrings subsystem
> perspective?

Thanks for reminding. Still catching up with keyring. I gave some
feedback to the patch.

/Jarkko
