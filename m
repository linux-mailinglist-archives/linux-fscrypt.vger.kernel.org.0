Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3816A2AFAB6
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Nov 2020 22:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgKKVu3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 Nov 2020 16:50:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgKKVu3 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 Nov 2020 16:50:29 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AC4720825;
        Wed, 11 Nov 2020 21:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605131428;
        bh=QRoFr36Q6SAzXDrDw2D8ClZBM19sNNwca4qXR6a3JK8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d1V5xJSuqMaslt51Cy7CukLB1k0GKfI8v+929UPZktlB+Zy4zwUtO6T0rigbhvG/M
         5qf/Hb3ucwPZVsc1tYGERbR5a2he4qH5m088htDlJnDDtccF9nPAF/wZf/f16q9dHQ
         Hl6yBDfus+oFIhOMBl2Euwk419xVIH4ITKUGCHtQ=
Date:   Wed, 11 Nov 2020 13:50:26 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] block/keyslot-manager: prevent crash when num_slots=1
Message-ID: <X6xcoosUcGscnTSt@sol.localdomain>
References: <20201111021427.466349-1-ebiggers@kernel.org>
 <20201111092305.GA13004@infradead.org>
 <20201111094538.GA3907007@google.com>
 <20201111192539.GB335825@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111192539.GB335825@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 11, 2020 at 11:25:39AM -0800, Eric Biggers wrote:
> On Wed, Nov 11, 2020 at 09:45:38AM +0000, Satya Tangirala wrote:
> > On Wed, Nov 11, 2020 at 09:23:05AM +0000, Christoph Hellwig wrote:
> > > On Tue, Nov 10, 2020 at 06:14:27PM -0800, Eric Biggers wrote:
> > > > +	 * hash_ptr() assumes bits != 0, so ensure the hash table has at least 2
> > > > +	 * buckets.  This only makes a difference when there is only 1 keyslot.
> > > > +	 */
> > > > +	slot_hashtable_size = max(slot_hashtable_size, 2U);
> > > 
> > > shouldn't this be a min()?
> > I think it should be max(), since we want whichever is larger between 2
> > and the original slot_hashtable_size :)
> 
> max() is correct.  I could just open-code it, if that would make it clearer:
> 
> 	/*
> 	 * hash_ptr() assumes bits != 0, so ensure the hash table has at least 2
> 	 * buckets.  This only makes a difference when there is only 1 keyslot.
> 	 */
> 	if (slot_hashtable_size < 2)
> 		slot_hashtable_size = 2;

I sent out v2 with the above.

- Eric
