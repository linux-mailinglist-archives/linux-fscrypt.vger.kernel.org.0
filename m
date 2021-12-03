Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45C346723D
	for <lists+linux-fscrypt@lfdr.de>; Fri,  3 Dec 2021 07:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378685AbhLCGzw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 3 Dec 2021 01:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233948AbhLCGzv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 3 Dec 2021 01:55:51 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C74C06174A;
        Thu,  2 Dec 2021 22:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aXFyrFXL34W2GHR0/Nvm2nUYcaAkgVvbt+pu+4SPxHo=; b=2Bh3M1lFWUbkvyW3FEXuOXaiAo
        i7u6LQiJ9HryjYiirrSbqsmzjgC8S5NKB0UqFUixHbp6hu3eeJzGaNfT7vMJHMuJo56XBCX6RZbsC
        keOcI0vyuDdr5+tKWiGwq7Ued6g7CK2EcYLwU/jiId0mt24kohFVkeHgZcmLoKMtOB3MYsTIDU4S0
        RmtSwngpujPT+z6BiFl/BXTKStDY7kUw8bwalKUywe6Zp35WnSvqVOB0CTJX8loyCDipuDRrdbbsO
        LkQtVp4jbqQz5v8KnKEFwpLtmgYScavc7n7vkoBRbIHkvHr+DDEIyaQsj9KGB6WR68Hlxap95VK1/
        pH5+0YFA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mt2QV-00EcqD-Aj; Fri, 03 Dec 2021 06:52:11 +0000
Date:   Thu, 2 Dec 2021 22:52:11 -0800
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
Message-ID: <Yam+m9eiLxIamGXm@infradead.org>
References: <81d5e825-1ee2-8f6b-cd9d-07b0f8bd36d3@linux.microsoft.com>
 <20211201163708.3578176-1-roberto.sassu@huawei.com>
 <Yahz1SYRG1CQIh0z@infradead.org>
 <e57d2d23ec7845febb79ca4476c73fcb@huawei.com>
 <YaiHX+dWNUlmsNac@infradead.org>
 <b4bf4a384b334cdab1522b3b082bd088@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4bf4a384b334cdab1522b3b082bd088@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 02, 2021 at 09:29:52AM +0000, Roberto Sassu wrote:
> The problem being solved is how to grant access to files
> which satisfy a property defined in the policy.

If you have want to enforce access to files in the block layer using
a specific stacking block driver you don't just have one layering
violation but a bunch of them.  Please go back to the drawing board.
