Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E938E0AE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Aug 2019 00:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbfHNWaO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 14 Aug 2019 18:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:32984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728262AbfHNWaO (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 14 Aug 2019 18:30:14 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AEA32064A
        for <linux-fscrypt@vger.kernel.org>; Wed, 14 Aug 2019 22:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565821813;
        bh=mFsFoNrwzPXXdfHQ0powTjM85TFXHli3r9SreBdDmF8=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=rYQfv75mMZ5XJaY/j+U+ofRKrWjzaP2W8bCvONDSxAIsuIdsdQJH5JnqumAkNNtwh
         z5ugPx+XhnP+pTkgYfMRdWkwA9ob+TDzK81kUURcpVn4eSpzrPzAVOlAeOMS/X5Mn0
         d1IMXBfj2gJAluEOMszfFgcGWj1IINS9PptA6jCU=
Date:   Wed, 14 Aug 2019 15:30:11 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] fscrypt: clean up base64 encoding/decoding
Message-ID: <20190814223011.GC101319@gmail.com>
Mail-Followup-To: linux-fscrypt@vger.kernel.org
References: <20190724194606.40483-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724194606.40483-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jul 24, 2019 at 12:46:06PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Some minor cleanups for the code that base64 encodes and decodes
> encrypted filenames and long name digests:
> 
> - Rename "digest_{encode,decode}()" => "base64_{encode,decode}()" since
>   they are used for filenames too, not just for long name digests.
> - Replace 'while' loops with more conventional 'for' loops.
> - Use 'u8' for binary data.  Keep 'char' for string data.
> - Fully constify the lookup table (pointer was not const).
> - Improve comment.
> 
> No actual change in behavior.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied to fscrypt tree for 5.4.

- Eric
