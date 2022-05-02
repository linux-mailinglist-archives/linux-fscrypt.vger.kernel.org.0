Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2A6516F67
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 May 2022 14:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384962AbiEBMTq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 May 2022 08:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384989AbiEBMTm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 May 2022 08:19:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A0D15A19;
        Mon,  2 May 2022 05:16:12 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242AmvWi021479;
        Mon, 2 May 2022 12:16:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=DGExP6oLSvLNaEuKQ24CJDRu/rp2Mv+OMa2OdAf8ywM=;
 b=J4O37aNkQX06kuW4bsa/zFP/FverwcmmLhAzFl6oaXs68K/HE65tUu+HcORsPCF9bGhX
 dtSgVUjXbZALmz2zwbsrdYBQjTzUBst5a3cwmOzHHluleez2SXv/LJdqkuUz3iZMHAE/
 AG2tYmnNShNVB5cXyl6nwwBES28zPIHhnA77fMaC1aM4eJPPrEKRgYBOes9Yae7+hS8f
 vuvSILZSY6+4S+xBJsRa7zLb7Lv1a7tR/gKR6bRXHJArWqLTo2F3pVhqnIwDWYzseTJG
 ZwjCtvxl5s9aBGrBy7fdD7YQNuzAwifvuzpDgVM67kPFgsZ/x8C5IlrjpcMB+hiEbSmC QA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ftdvjhpga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 12:16:09 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 242CCOqr005991;
        Mon, 2 May 2022 12:16:07 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3frvcj2p7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 12:16:07 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 242CG5iX56295876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 May 2022 12:16:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C8FF42041;
        Mon,  2 May 2022 12:16:05 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0E694203F;
        Mon,  2 May 2022 12:16:04 +0000 (GMT)
Received: from sig-9-65-70-224.ibm.com (unknown [9.65.70.224])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 May 2022 12:16:04 +0000 (GMT)
Message-ID: <18587675b3c6ebc74b81cabe53dc293099304861.camel@linux.ibm.com>
Subject: Re: [PATCH v8 6/7] ima: support fs-verity file digest based version
 3 signatures
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Stefan Berger <stefanb@linux.ibm.com>,
        linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 02 May 2022 08:16:04 -0400
In-Reply-To: <8a18eb04-4d07-7bad-e6f9-0015788e6a11@linux.ibm.com>
References: <20220429112601.1421947-1-zohar@linux.ibm.com>
         <20220429112601.1421947-7-zohar@linux.ibm.com>
         <8a18eb04-4d07-7bad-e6f9-0015788e6a11@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: N88oVwMXZoq6HL5Rw2n3PO8mIChkA1Rj
X-Proofpoint-GUID: N88oVwMXZoq6HL5Rw2n3PO8mIChkA1Rj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_04,2022-05-02_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205020094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

> > @@ -225,6 +232,40 @@ int ima_read_xattr(struct dentry *dentry,
> >   	return ret;
> >   }
> >   
> > +/*
> > + * calc_file_id_hash - calculate the hash of the ima_file_id struct data
> > + * @type: xattr type [enum evm_ima_xattr_type]
> > + * @algo: hash algorithm [enum hash_algo]
> > + * @digest: pointer to the digest to be hashed
> > + * @hash: (out) pointer to the hash
> > + *
> > + * IMA signature version 3 disambiguates the data that is signed by
> > + * indirectly signing the hash of the ima_file_id structure data.
> > + *
> > + * Signing the ima_file_id struct is currently only supported for
> > + * IMA_VERITY_DIGSIG type xattrs.
> > + *
> > + * Return 0 on success, error code otherwise.
> > + */
> > +static int calc_file_id_hash(enum evm_ima_xattr_type type,
> > +			     enum hash_algo algo, const u8 *digest,
> > +			     struct ima_digest_data *hash)
> > +{
> > +	struct ima_file_id file_id = {
> > +		.hash_type = IMA_VERITY_DIGSIG, .hash_algorithm = algo};
> > +	unsigned int unused = HASH_MAX_DIGESTSIZE - hash_digest_size[algo];
> > +
> > +	if (type != IMA_VERITY_DIGSIG)
> > +		return -EINVAL;
> > +
> > +	memcpy(file_id.hash, digest, hash_digest_size[algo]);
> > +
> > +	hash->algo = algo;
> > +	hash->length = hash_digest_size[algo];
> > +
> > +	return ima_calc_buffer_hash(&file_id, sizeof(file_id) - unused, hash);
> 
> +struct ima_file_id {
> +	__u8 hash_type;		/* xattr type [enum evm_ima_xattr_type] */
> +	__u8 hash_algorithm;	/* Digest algorithm [enum hash_algo] */
> +	__u8 hash[HASH_MAX_DIGESTSIZE];
> +} __packed;
> 
> did you maybe mean 'sizeof(file_id.hash) - unused' ?

No, the hash includes the other fields as well.  Instead of including a
flexible array in struct ima_file_id and dynamically allocating the
memory for the struct with the specific hash size, the maximum sized
hash is included in the struct.
> 
> 
> > +}
> > +


> > diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> > index 390a8faa77f9..e24531db95cd 100644
> > --- a/security/integrity/ima/ima_policy.c
> > +++ b/security/integrity/ima/ima_policy.c
> > @@ -1310,6 +1310,15 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
> >   	    !(entry->flags & IMA_MODSIG_ALLOWED))
> >   		return false;
> >   
> > +	/*
> > +	 * Ensure verity appraise rules require signature format v3 signatures
> > +	 * ('appraise_type=sigv3').
> 
> This comment doesn't seem to reflect what is actually checked below ... 
> at least for me it's difficult to see that.
> 
> It's more like 'ensure that appraise rules for verity signature type 
> also have the IMA_DIGSIG_REQUIRED flag set.'

Generally code should be understandable without requiring a comment.  
In this case, the purpose of the comment is to require a file
signature.  Here's the updated comment:

+        * Unlike for regular IMA 'appraise' policy rules where
security.ima
+        * xattr may contain either a file hash or signature, the
security.ima
+        * xattr for fsverity must contain a file signature
(sigv3).  Ensure
+        * that 'appraise' rules for fsverity require file signatures
by
+        * checking the IMA_DIGSIG_REQUIRED flag is set.


> > +	 */
> > +	if (entry->action == APPRAISE &&
> > +	    (entry->flags & IMA_VERITY_REQUIRED) &&
> > +	    !(entry->flags & IMA_DIGSIG_REQUIRED))
> > +		return false;
> > +
> >   	return true;
> >   }
> >   

thanks,

Mimi

