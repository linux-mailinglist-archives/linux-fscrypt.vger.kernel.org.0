Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 942B8FE84C
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Nov 2019 23:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfKOWxZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Nov 2019 17:53:25 -0500
Received: from mga05.intel.com ([192.55.52.43]:31051 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbfKOWxZ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Nov 2019 17:53:25 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Nov 2019 14:53:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,309,1569308400"; 
   d="scan'208";a="230598878"
Received: from bpgilles-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.95.141])
  by fmsmga004.fm.intel.com with ESMTP; 15 Nov 2019 14:53:20 -0800
Date:   Sat, 16 Nov 2019 00:53:19 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, "Theodore Y . Ts'o" <tytso@mit.edu>,
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
Message-ID: <20191115225319.GB29389@linux.intel.com>
References: <20191107001259.115018-1-ebiggers@kernel.org>
 <20191115172832.GA21300@linux.intel.com>
 <20191115192227.GA150987@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115192227.GA150987@sol.localdomain>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Nov 15, 2019 at 11:22:27AM -0800, Eric Biggers wrote:
> On Fri, Nov 15, 2019 at 07:28:53PM +0200, Jarkko Sakkinen wrote:
> > 
> > I don't see anything obviously wrong. Just would reformat it a bit.
> > How you tested it?
> > 
> 
> I'm not sure all the blank lines you're suggesting would be an improvement.
> The ones in fscrypt_provisioning_key_preparse() might make sense though.

OK. Some of this aesthics comes from the feedback that I've received
during Intel SGX patch set review process (of course subsystem is
different i.e. x86). I tend to agree at least that before a new
conditional statement it is more readable if there is a blank line
before it.

> I'm working on an xfstest for this:
> 
> 	https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git/commit/?h=fscrypt-provisioning&id=24ab6abb7cf6a80be44b7c72b73f0519ccaa5a97
> 
> It's not quite ready, though.  I'll post it for review when it is.
> 
> Someone is also planning to update Android userspace to use this.  So if there
> are any issues from that, I'll hear about it.

Cool. Can you combine this patch and matching test (once it is done) to
a patch set?

/Jarkko
