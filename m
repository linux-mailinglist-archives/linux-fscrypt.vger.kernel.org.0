Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7BCFDF60A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Oct 2019 21:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbfJUTa2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Oct 2019 15:30:28 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:32815 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726672AbfJUTa1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Oct 2019 15:30:27 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-98.corp.google.com [104.133.0.98] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x9LJUKLB017773
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Oct 2019 15:30:21 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id D6972420458; Mon, 21 Oct 2019 15:30:19 -0400 (EDT)
Date:   Mon, 21 Oct 2019 15:30:19 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Chandan Rajendra <chandan@linux.ibm.com>
Subject: Re: [xfstests-bld PATCH] test-appliance: add ext4/encrypt_1k test
 config
Message-ID: <20191021193019.GI27850@mit.edu>
References: <20191016221552.299566-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016221552.299566-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 16, 2019 at 03:15:52PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add a test configuration to allow testing ext4 encryption with 1k
> blocks, which kernel patches have been proposed to support.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
