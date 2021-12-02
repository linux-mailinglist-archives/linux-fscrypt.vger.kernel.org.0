Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03335465E9C
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 08:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345485AbhLBHYn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 02:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345415AbhLBHYm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 02:24:42 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1409C061574;
        Wed,  1 Dec 2021 23:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rqO5y6tHMaMK9eTexEF756VFsX+GgPuXTh5uGfxFaBk=; b=rCceHGLVni7wC5PsXHlpbGqfg3
        Gae/8XyFn8y4oyg+Qw5og/bCu3s/+TNzPPqDQem4/nhBhWAtOC2vyqMKBN/6Xc+/rSVQEAiVWF7mz
        koQPaa/bLFZbc5KJwRwGPUSoBqP6HfJhEZtzXVyt060HryAfkt/pKwqKSqfn6Oi8bitBmO7e62qSa
        ojk+kcXmsi5Rjx17eX/f1OFOBe0cHtek9rXkUXs5jzEB3mTEfInnWXhtcR57vkB9AlNyb7SGsiYml
        EoHpJHoWf6svwRQPdOZfr+ILiS8MktFI27w5MEqskeVR8MFTXyKf88CtE9kpLnax+ilGu1kTkLGlq
        bFtKQQRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1msgOj-00BArf-A8; Thu, 02 Dec 2021 07:20:53 +0000
Date:   Wed, 1 Dec 2021 23:20:53 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     deven.desai@linux.microsoft.com, corbet@lwn.net, axboe@kernel.dk,
        agk@redhat.com, snitzer@redhat.com, ebiggers@kernel.org,
        tytso@mit.edu, paul@paul-moore.com, eparis@redhat.com,
        jmorris@namei.org, serge@hallyn.com, jannh@google.com,
        dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, tusharsu@linux.microsoft.com
Subject: Re: [RFC][PATCH] device mapper: Add builtin function dm_get_status()
Message-ID: <Yahz1SYRG1CQIh0z@infradead.org>
References: <81d5e825-1ee2-8f6b-cd9d-07b0f8bd36d3@linux.microsoft.com>
 <20211201163708.3578176-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201163708.3578176-1-roberto.sassu@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Dec 01, 2021 at 05:37:08PM +0100, Roberto Sassu wrote:
> Users of the device mapper driver might want to obtain a device status,
> with status types defined in the status_type_t enumerator.

The patch looks really odd.  And without the corresponding user of your
new functionality it is entirely unreviewable anyway.
