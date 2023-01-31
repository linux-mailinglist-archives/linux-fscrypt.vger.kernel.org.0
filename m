Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA156827D8
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Jan 2023 09:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbjAaI7l (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Jan 2023 03:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbjAaI7J (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Jan 2023 03:59:09 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D334A200;
        Tue, 31 Jan 2023 00:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rhCsY2V0K1JQeXvbPkK1YWpb3KV/lJbLEv47FklFMsc=; b=AJpWk7PFgIkQ65NH1xZDrHA8dA
        zcE+UrpQk44ftE4ODzzdPDWZxqHIyCV7gDGmfU8DcKgLw2CxLDXHS/fDEfGMSj0djjqGex7ft++Ni
        mGFuW7NUcKBAybLe47VGeHeaZh4Hl4WQnQJfOUr0desMJXgFKyfDK9nfaC3OUwO8wFsryQr8saSJ9
        SPEFU+T9MiWlcbBo2AXaxRCgIqMZDV07wBZFUZ8iQIlpv2Uu61T2Bj9wOK2mcyHxBUEBdVHYBYOzg
        P00CdzXkXg9uuQgP7Kh1hdvDUfU2hNJGapy2l3PaxhHAVNBcRx6GpW/bfQ+VD9WDZYcDhn+v5dtmv
        hP7a/mbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMmOt-006rfW-RR; Tue, 31 Jan 2023 08:53:59 +0000
Date:   Tue, 31 Jan 2023 00:53:59 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Fan Wu <wufan@linux.microsoft.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 09/16] block|security: add LSM blob to block_device
Message-ID: <Y9jXJ8FrmAnzob7w@infradead.org>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-10-git-send-email-wufan@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675119451-23180-10-git-send-email-wufan@linux.microsoft.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 30, 2023 at 02:57:24PM -0800, Fan Wu wrote:
> From: Deven Bowers <deven.desai@linux.microsoft.com>
> 
> block_device structures can have valuable security properties,
> based on how they are created, and what subsystem manages them.

That's a lot of cloudy talk but no real explanation.
