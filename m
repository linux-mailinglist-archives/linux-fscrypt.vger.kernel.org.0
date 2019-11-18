Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B056F100B04
	for <lists+linux-fscrypt@lfdr.de>; Mon, 18 Nov 2019 19:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfKRSCe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Nov 2019 13:02:34 -0500
Received: from mga18.intel.com ([134.134.136.126]:41416 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfKRSCe (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Nov 2019 13:02:34 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Nov 2019 10:02:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,321,1569308400"; 
   d="scan'208";a="380733937"
Received: from cooperwu-mobl.gar.corp.intel.com (HELO localhost) ([10.252.3.195])
  by orsmga005.jf.intel.com with ESMTP; 18 Nov 2019 10:02:23 -0800
Date:   Mon, 18 Nov 2019 20:02:22 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>, g@linux.intel.com
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Paul Lawrence <paullawrence@google.com>,
        keyrings@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, David Howells <dhowells@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Ondrej Kozina <okozina@redhat.com>
Subject: Re: [PATCH] fscrypt: support passing a keyring key to
 FS_IOC_ADD_ENCRYPTION_KEY
Message-ID: <20191118180222.GC5984@linux.intel.com>
References: <20191107001259.115018-1-ebiggers@kernel.org>
 <20191115172832.GA21300@linux.intel.com>
 <20191115192227.GA150987@sol.localdomain>
 <20191115225319.GB29389@linux.intel.com>
 <20191116000139.GB18146@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116000139.GB18146@mit.edu>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Nov 15, 2019 at 07:01:39PM -0500, Theodore Y. Ts'o wrote:
> On Sat, Nov 16, 2019 at 12:53:19AM +0200, Jarkko Sakkinen wrote:
> > > I'm working on an xfstest for this:
> > > 
> > > 	https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git/commit/?h=fscrypt-provisioning&id=24ab6abb7cf6a80be44b7c72b73f0519ccaa5a97
> > > 
> > > It's not quite ready, though.  I'll post it for review when it is.
> > > 
> > > Someone is also planning to update Android userspace to use this.  So if there
> > > are any issues from that, I'll hear about it.
> > 
> > Cool. Can you combine this patch and matching test (once it is done) to
> > a patch set?
> 
> That's generally not done since the test goes to a different repo
> (xfstests.git) which has a different review process from the kernel
> change.

OK, sorry, both fscrypt and xfstests are both somewhat alien to me. That
is why I'm looking into setting up test environment so that I can review
these patches with a sane judgement.

/Jarkko
