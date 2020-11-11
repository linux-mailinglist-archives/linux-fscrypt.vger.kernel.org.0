Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352D22AED64
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Nov 2020 10:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgKKJXI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 Nov 2020 04:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbgKKJXH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 Nov 2020 04:23:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05182C0613D1;
        Wed, 11 Nov 2020 01:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AJNkxtTUYYvBgPQgfvtAW6wM58Zlg92jNTmXhhCZPr0=; b=jyFGSGVrurZSgO0ETYisJ1/0PG
        SLLaXYy6B6SFyrsS3U92YygWP6OZ7u6Q5HCgGsUL6vcFmDTEX7H2DV7DYxR29ep7nG/J4q9hZex3s
        OIvkMOq/YwixnwyZmf6mhDlZNm/ucuseI1q1KFFz2OOC5nYLuCLZXW0WQoiCiiBCfUguqcVOK0S9W
        du7SbaUVksRubxbW4mTKcGb4/rmej6uMtUpW/Zk/f6ZPZtRu0V8CQjXozswewLudrW9lBXFrcRs44
        7hmzAynvJ0VGUhXb79O3MKZH4UqiLgMyIFlyVKmeuTfQRDdv48vxKY18ZeNRXjxT8vz27KHz4XM/f
        GHTFEOZQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcmLJ-0003R8-3Z; Wed, 11 Nov 2020 09:23:05 +0000
Date:   Wed, 11 Nov 2020 09:23:05 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: Re: [PATCH] block/keyslot-manager: prevent crash when num_slots=1
Message-ID: <20201111092305.GA13004@infradead.org>
References: <20201111021427.466349-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111021427.466349-1-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Nov 10, 2020 at 06:14:27PM -0800, Eric Biggers wrote:
> +	 * hash_ptr() assumes bits != 0, so ensure the hash table has at least 2
> +	 * buckets.  This only makes a difference when there is only 1 keyslot.
> +	 */
> +	slot_hashtable_size = max(slot_hashtable_size, 2U);

shouldn't this be a min()?
