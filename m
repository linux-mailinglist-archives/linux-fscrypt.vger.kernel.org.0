Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B97B465FC4
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 09:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356135AbhLBIsA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 03:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhLBIsA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 03:48:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62149C061574;
        Thu,  2 Dec 2021 00:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WHKKBPmZzl+iVI6ViVcyceHemgSPQgPyjDvFKJ+O5xA=; b=g1hj+bDi1Oqg96mxjLjMeGlSe9
        xyXSTpXzBrowXbPr7cOgE4CYmonMn0bCEje/94qcZE0v9sxwHdopckQXyXDbqbGhmbdFMKTkJ+Vzv
        8v5X1rGauU6htn0eCCc6ho57OHadSDsKHmnRPoQWCLTaa7hu0NtPeuEF5XhfpT7NFlNDIYFyGNPkV
        gGr6U3uY5VMIZimsLvkQ6qhGNOP1hk7CJB0GTMSb6zou0byil6fB4QUqx/h3P/29ft6/o2dffn3Lz
        iqxbqJRJsQDOG3a0xC/2POvZjD744FrUqXb+sLJBQE6cw2Yh2Vzcb9/RuseZ27LZGjk8WXPiHe3bJ
        s4G0L27g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mshhP-00BSzO-PW; Thu, 02 Dec 2021 08:44:15 +0000
Date:   Thu, 2 Dec 2021 00:44:15 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "deven.desai@linux.microsoft.com" <deven.desai@linux.microsoft.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "jannh@google.com" <jannh@google.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "tusharsu@linux.microsoft.com" <tusharsu@linux.microsoft.com>
Subject: Re: [RFC][PATCH] device mapper: Add builtin function dm_get_status()
Message-ID: <YaiHX+dWNUlmsNac@infradead.org>
References: <81d5e825-1ee2-8f6b-cd9d-07b0f8bd36d3@linux.microsoft.com>
 <20211201163708.3578176-1-roberto.sassu@huawei.com>
 <Yahz1SYRG1CQIh0z@infradead.org>
 <e57d2d23ec7845febb79ca4476c73fcb@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e57d2d23ec7845febb79ca4476c73fcb@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 02, 2021 at 07:59:38AM +0000, Roberto Sassu wrote:
> ok, I will send it together with a patch for a not yet accepted
> software, Integrity Policy Enforcement (IPE), that will be
> the primary user of the introduced functionality.
> 
> Regarding the patch itself, could you please provide a more
> detailed explanation?

We don't build things into the kernel just as hooks.  So in doubt you
need to restructured the code.  And that a security module pokes into
a random block driver is a big hint that whatever you're trying to do is
completely broken.
