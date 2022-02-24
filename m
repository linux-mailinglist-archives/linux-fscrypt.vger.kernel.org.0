Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0AA24C2164
	for <lists+linux-fscrypt@lfdr.de>; Thu, 24 Feb 2022 02:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiBXBzO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 23 Feb 2022 20:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiBXBzO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 23 Feb 2022 20:55:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9790949901;
        Wed, 23 Feb 2022 17:54:45 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NLknP1007256;
        Thu, 24 Feb 2022 01:21:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=dy+WaOjEGb/+byPq+LMneqdJ8ZUeXAvTiYBdF0B4VjE=;
 b=Q1ovKxLbiCb26NbYTHHzBnlgb5sph1WpQOYVygrtMtD/7GXWqwk0ayAN0Ia34IdDwte7
 O4WhWsP6ED3Yg11BgoFQ4b8fk49ozTnwPd2Y4wfmXsRyZSXUzZOomFv0Cy8UGtDAo3yc
 ZHaKGLDA7jlXe2afjVOjBqL7gh1bfy51svCaE0nahFZo6MKVoiF0iUxw/dp5sVMP+p2h
 lTXWxLiP/Bq9zgH54uJsr3T4BqTN6WIuTw240ZMCfELwzZsl1EcJ09vKhjyjzS6X2P5l
 wVPFbFyFs2o2D1ZIOkzCxiVgRBwBRkWy+IwhF22Xcyqi9a55fC/VNkbmC3G6iakcG+2f tg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edw513k2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 01:21:07 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21O18B6g029736;
        Thu, 24 Feb 2022 01:21:05 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3ear69ksy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 01:21:05 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21O1L3BN49021226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 01:21:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18EF25204F;
        Thu, 24 Feb 2022 01:21:03 +0000 (GMT)
Received: from sig-9-65-80-154.ibm.com (unknown [9.65.80.154])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 521C75204E;
        Thu, 24 Feb 2022 01:21:02 +0000 (GMT)
Message-ID: <f322ae351dde71b92d7d4037d78190c7338ca710.camel@linux.ibm.com>
Subject: Re: [PATCH v5 3/8] fs-verity: define a function to return the
 integrity protected file digest
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Feb 2022 20:21:01 -0500
In-Reply-To: <YhbKYZcWxmi4auJU@sol.localdomain>
References: <20220211214310.119257-1-zohar@linux.ibm.com>
         <20220211214310.119257-4-zohar@linux.ibm.com>
         <YhbKYZcWxmi4auJU@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 44v8-ClwRKkbiM19w30QSAMnC5H7WXKk
X-Proofpoint-ORIG-GUID: 44v8-ClwRKkbiM19w30QSAMnC5H7WXKk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_09,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202240002
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2022-02-23 at 15:59 -0800, Eric Biggers wrote:
> On Fri, Feb 11, 2022 at 04:43:05PM -0500, Mimi Zohar wrote:
> > +/**
> > + * fsverity_get_digest() - get a verity file's digest
> > + * @inode: inode to get digest of
> > + * @digest: (out) pointer to the digest
> > + * @alg: (out) pointer to the hash algorithm enumeration
> > + *
> > + * Return the file hash algorithm and digest of an fsverity protected file.
> > + *
> > + * Return: 0 on success, -errno on failure
> > + */
> > +int fsverity_get_digest(struct inode *inode,
> > +			u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
> > +			enum hash_algo *alg)
> > +{
> > +	const struct fsverity_info *vi;
> > +	const struct fsverity_hash_alg *hash_alg;
> > +	int i;
> > +
> > +	vi = fsverity_get_info(inode);
> > +	if (!vi)
> > +		return -ENODATA; /* not a verity file */
> 
> Sorry for the slow reviews; I'm taking a look again now.  One question about
> something I missed earlier: is the file guaranteed to have been opened before
> this is called?  fsverity_get_info() only returns a non-NULL value if the file
> has been opened at least once since the inode has been loaded into memory.  If
> the inode has just been loaded into memory without being opened, for example due
> to a call to stat(), then fsverity_get_info() will return NULL.
> 
> If the file is guaranteed to have been opened, then the code is fine, but the
> comment for fsverity_get_digest() perhaps should be updated to mention this
> assumption, given that it takes a struct inode rather than a struct file.
> 
> If the file is *not* guaranteed to have been opened, then it would be necessary
> to make fsverity_get_digest() call ensure_verity_info() to set up the
> fsverity_info.

Yes, fsverity_get_digest() is called as a result of a syscall - open,
execve, mmap, etc.   
Refer to the LSM hooks security_bprm_check() and security_mmap_file().
ima_file_check() is called directly in do_open().

Mimi

